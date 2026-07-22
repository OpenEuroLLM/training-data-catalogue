# Dataset Ingestion Pipeline

How a dataset makes its way into the OpenEuroLLM Training Data Catalogue: from
the issue nominating it, through download and format conversion, to the corpus
statistics and the published catalogue entry.

This document is descriptive rather than a runbook. The pipeline is tailored to
how this catalogue is curated and runs on LUMI with SLURM, so paths, allocations,
and scheduler details will differ in any other setting. It is written for users
who want to understand the approach or adopt something similar.

The catalogue is published read-only on LUMI at
`/appl/local/openeurollm/training/catalogue/`, and mirrored on other EuroHPC
systems. Supporting scripts, documentation, and aggregated statistics live in the
[catalogue repository](https://github.com/OpenEuroLLM/training-data-catalogue);
paths like [`etc/counts.array.slurm`](etc/counts.array.slurm) below are relative
to it. The repository
holds no data files.


## 1. Nomination

A dataset enters the pipeline as a
[GitHub issue](https://github.com/OpenEuroLLM/training-data-catalogue/issues).
Anyone may nominate a resource or raise questions about an emerging entry.
Selection favours openly licensed datasets with minimal legal uncertainty; the
criteria, and the lifecycle an entry follows once accepted, are set out in the
[catalogue README](README.md).

Three things are settled before work begins:

- **Entry name.** A catalogue entry name need not correspond to the name of the
  Hugging Face repository the data comes from -- `open-web-math` is catalogued as
  `openwebmath`. The distinction propagates into every later path, so it is worth
  fixing early.
- **Version.** Entries are laid out as `<dataset>/<version>/`, e.g. `hplt/3.0/`
  or `fineweb/2.1.0/`. The version follows the dataset authors' own label where
  there is one, and `0.0.0` is used where they publish none.
- **Scope.** The whole dataset, or only selected stages or configurations.


## 2. Download

Data is downloaded to a temporary location outside the catalogue, so that a
failed or partial download never appears as a catalogue entry.

Most datasets come from the Hugging Face Hub, though nothing in the pipeline
depends on that. For Hub downloads there are two options: a `git lfs` clone of
the dataset repository, or the `hf download` CLI, which can fetch part of a
repository through an `--include` pattern and parallelizes transfers. In practice
`git lfs` has seen more use -- it has proven more stable on large repositories,
and `git lfs fsck` afterwards gives a basic check that what arrived is intact.

[`etc/download-dataset.slurm`](etc/download-dataset.slurm) covers the general
case, taking a dataset and a revision. Whenever a dataset needs handling of its
own, a variant of the script lives in that entry's `etc/` directory;
[`swallow-code/2.0/etc/download.slurm`](swallow-code/2.0/etc/download.slurm) is
one such, fetching a single processing stage of a larger repository.

Downloads are large and long-running, so they are submitted as batch jobs rather
than run interactively.


## 3. Conversion

The catalogue standardizes on JSONlines: one JSON object per document, serialized
as a single line with no internal line breaks, carrying the document text plus
whatever metadata the source defines.

Files are compressed with
[Zstandard](https://datatracker.ietf.org/doc/html/rfc8878) for storage
efficiency, hence the `.jsonl.zst` extension on catalogue data files.

Datasets that already arrive as gzipped JSONlines are an exception: they are kept
as they are, under the names they came with, for consistency with how the dataset
is distributed. That is usually `.jsonl.gz`, though some datasets use `.json.gz`
even though the contents are JSONlines. A recompression script exists for
converting these to zstd, but in the end it has not been used.

The conversion step itself reads Parquet files and writes compressed JSONlines.
This is the only kind of conversion the pipeline has needed so far, and the
array job looks specifically for files ending in `.parquet`.

Conversion runs as a SLURM array job
([`etc/convert.array.slurm`](etc/convert.array.slurm)), driven by a filelist. A
first pass enumerates the source files and writes them out as a list, and the
array then works through that list, each task handling a contiguous slice of it.
How finely the list is divided, and how many of those slices run at the same
time, are both decided when the job is submitted. This is worth a moment's
thought, because LUMI permits 200 jobs per user and counts array tasks
individually, which makes 190 slices the usual choice. A longer filelist is
simply divided more finely and worked through in several waves, as described
under [Operational Notes](#operational-notes).

The converted files mirror the directory structure of the source, written beneath
the entry's version directory. There is no strict rule for what the directory
below that is called. `data` is the common case, but datasets published as named
subsets keep those names, and in general the layout follows whatever suits the
source.

Each task skips files whose output already exists, so an array that fails part of
the way through can be resubmitted as it stands. Note that the check is for
existence, not completeness, so a file left truncated by a killed task would be
skipped as done. Remove the outputs of any task that died mid-file before
resubmitting.

Input and output locations can be controlled with `--input-prefix`, which
restricts conversion to a subdirectory of the source, and `--output-revision`,
which sets the catalogue version to write under.


## 4. Counts

Each entry is accompanied by basic statistics, as outlined in the
[README](README.md#corpus-statistics). These are produced by
[`etc/counts.array.slurm`](etc/counts.array.slurm), a filelist-driven array job
much like conversion, which calls
[`etc/counts_runner.py`](etc/counts_runner.py) to do the actual work.

A hidden per-file record sits beside each data file, so the work happens once per
file and re-runs skip what is already done. The script has four phases:

- `--init` -- enumerates the data files matching a pattern and writes the
  filelist the array works through
- *no flag* -- the array proper, loading the tokenizer once per task and writing
  one record per data file
- `--aggregate` -- walks the entry's tree upward, summing records into a
  `counts.json` at each level, so every directory carries the totals beneath it.
  Fails if any record is missing rather than under-reporting.
- `--report` -- renders `counts.md`, the per-partition totals, and `fields.md`,
  the metadata fields present in the data, each marked required or optional

Once the counts are done, the hidden per-file records are deleted. `counts.md`
and `fields.md` are embedded into the entry's README and deleted as well. The
`counts.json` files are kept and committed to the repository, where they also
capture the entry's directory structure.


## 5. Indexing

Some entries are additionally indexed.
[`etc/index.py`](etc/index.py) reads each data file and writes hidden compressed
index files beside it, each mapping a hash to the documents it occurs in, with an
occurrence count and the positions where it was seen. **Signatures** are built
over the document text, normalized by stripping non-word characters and
lowercasing. **Domains** and **urls** are built over the document's URL, and are
written only for datasets whose records carry one. Existing indices are left
alone unless regeneration is forced.


## 6. Analytics

Some entries carry an `analytics/` directory beside the README, holding one YAML
file per language, named by language code.

Each file covers one language partition: a short header (corpus, source language,
timestamp, warnings) followed by distributional summaries, stored as
JSON-serialized lists of pairs inside YAML strings. They cover documents per
source crawl, per detected language and per segment count, token, character and
unique-sentence totals, PII and filtering-rule tags, and a data sample.


## 7. The Catalogue Entry

The visible result of ingestion is a `README.md` at `<dataset>/<version>/` in the
repository, following a common structure so that entries can be read against each
other. [`etc/skeleton.md`](etc/skeleton.md) is the empty template. The entry is
then listed in the top-level [`README.md`](README.md) under its category, linked
and with a citation.

### Language subsets

The [`languages`](languages) file lists the target languages by category -- EU
official, EU candidate, EU minority or regional, and other target languages --
and is the canonical reference for per-language selections and statistics.

Datasets covering more languages than this target set may carry an
`openeurollm/` subdirectory presenting the relevant subset. It contains only
relative symlinks, never copies; whether whole directories or individual files
are linked depends on how the source is laid out.


## Operational Notes

Operational specifics of the LUMI setup. These are the parts most likely to
differ, or to be wrong, in another environment.

### Counting, end to end

```bash
# 1. enumerate files and write the filelist
bash counts.array.slurm --init [--pattern REGEX] <target_dir>

# 2. submit the array, N tasks
sbatch --array=1-N --output='logs/%x-%A-%a.out' counts.array.slurm --max-tasks N <target_dir>

# 3. after the array finishes
bash counts.array.slurm --aggregate <target_dir>
bash counts.array.slurm --report <target_dir>
```

- `--max-tasks N` sets how many slices the filelist is cut into; the script
  derives the per-task batch size from it. `--array` selects which of those
  slices actually run. In the simple case the two match: `--max-tasks 190` with
  `--array=1-190`. It is not an argument to `--init`.
- Waves: when the filelist needs more slices than the 200-job limit allows to run
  at once, cut it into more slices and run them in several passes, e.g.
  `--max-tasks 500` with `--array=1-190`, then `--array=191-380`, then
  `--array=381-500`. `--max-tasks` stays the same across all of them -- it
  defines the slicing, so changing it mid-way would shift the boundaries.
- No `--parsable`, and no `--dependency` chaining -- aggregate is run separately
  once the array has finished.
- Aggregate and report are small and normally run on the login node with `bash`.
  Aggregate can equally be submitted with `sbatch` for a very large tree.
- Default file pattern is `\.zst$`; pass `--pattern '\.gz$'` for gzip entries.
  `--key` selects the JSON field holding the text, default `text`.

Conversion follows the same `--init`-then-submit shape, and the same slicing and
wave mechanics.

### SLURM

- Maximum 200 jobs per user, with array tasks counted individually. Check
  `squeue --me` before submitting an array and size it to the free slots, leaving
  a buffer.
- CPU jobs run against a LUMI project allocation (`--account=project_XXXXXXXXX`).
- `--mem-per-cpu=1750` is the default; counting needs `8G` for entries with large
  individual files, which otherwise OOM.
- Array jobs must log per task: `--output='logs/%x-%A-%a.out'`. Never `%j` for an
  array -- every task opens that one file in write mode and only the last task's
  output survives.
- Submit scripts from their own `etc/` directory; they resolve the virtual
  environment and Python helpers by relative path.
- Never infer that a job finished from an output directory existing. Check the
  logs or the queue.
- Use `lumi-quota` for disk and file quota, not `df` or `lfs quota`.
- Keep heavy work off the login node. For integrity checks, prefer comparing
  byte sizes to decompressing content.

### Verifying an entry's stated statistics

Run inside the entry's data directory -- usually `data/`, but not always; some
entries name it differently or split across partitions with no single data
directory:

```bash
find . -name '*.jsonl.zst' | wc -l
du -hd1
```

Watch for an `openeurollm/` sibling: it holds symlinks to a language subset of
the same files, and including it double-counts files and inflates the size.

### Entry conventions

Easy to get subtly wrong when writing an entry README:

- Section headings carry their own anchors, as in
  `## <a id="citation">References</a>`. Copy them from
  [`etc/skeleton.md`](etc/skeleton.md).
- "Hugging Face" is two words in prose; URLs (`huggingface.co`) and identifiers
  (`HuggingFaceFW`, `huggingface_hub`) keep their own spelling.
- Two sentences are used verbatim catalogue-wide: "Additional details are
  available on the [Hugging Face dataset page](URL)." and "The primary download
  site for the data is the [Hugging Face Hub](URL)."

### Code style

- Plain ASCII only, in code, comments, string literals, and docstrings.
- Dataset-specific scripts hardcode their values rather than growing options.
  Prefer calling the shared scripts in `etc/` with the right arguments; write a
  self-contained script only when the logic genuinely warrants it.
- Data processing scripts fail hard on anomalies. No silent skipping, no
  swallowed errors -- a wrong number that looks plausible is worse than a crash.

### Scripts

| Script | Purpose |
|---|---|
| `etc/download-dataset.slurm` | Generic Hugging Face download (git lfs or `hf download`) |
| `etc/convert.array.slurm` | Filelist array job, Parquet -> JSONL.ZST |
| `etc/convert_single_parquet_to_jsonl.py` | Per-file converter called by the array job |
| `etc/counts.array.slurm` | Filelist array job for counting |
| `etc/counts_runner.py` | CLI wrapper: `count-files` / `aggregate` / `report` |
| `etc/counts.py` | Counting implementation |
| `etc/index.py` | Signature / domain / URL indices; overlap analysis |
| `etc/recompress.slurm` | Array job, `.gz` -> `.zst` |
| `etc/verify-gzip.slurm` | Array job, `.gz` integrity verification |
| `etc/huggingface.py` | Hugging Face API helpers (list files, configs) |
| `etc/preamble.sh` | Common shell setup sourced by per-dataset SLURM scripts |
| `etc/skeleton.md` | Empty README template |

`convert.slurm` and `counts.slurm` are earlier single-directory versions of the
two array jobs, superseded by the filelist-based ones.
