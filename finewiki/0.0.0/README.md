# FineWiki

**[DRAFT] (Version 0.0.0; May 2026)**

## <a id="background">Background</a>

FineWiki is a multilingual Wikipedia dataset covering 325 languages, based on the August 2025
Wikimedia Enterprise HTML dump snapshot. Unlike earlier Wikipedia extractions that parse wikitext,
FineWiki extracts text from pre-rendered HTML, which fully expands templates and preserves
rich formatting including headings, lists, tables, code blocks, and mathematical content.
Details are available on the [HuggingFace dataset page](https://huggingface.co/datasets/HuggingFaceFW/finewiki).

## <a id="sources">Data Sources</a>

[Wikipedia](https://www.wikipedia.org/) via the [Wikimedia Enterprise HTML Dump API](https://api.enterprise.wikimedia.com/v2/snapshots) (main namespace only, August 2025 snapshot).
HTML was parsed using an adapted version of [mwparserfromhtml](https://pypi.org/project/mwparserfromhtml/),
with boilerplate removal (table of contents, navboxes, categories, reference sections),
infobox extraction, and filtering for redirects, disambiguation pages, ultra-short articles,
and script/language consistency.

## <a id="statistics">Structure & Statistics</a>

The dataset is distributed as 404 Zstd-compressed JSONlines files, amounting to 114 GB on disk.
Files are organized into 325 per-language directories named after the wiki (e.g. `enwiki`, `dewiki`),
each containing one or more files following the naming pattern `000_NNNNN.jsonl.zst`.

## <a id="metadata">Available Metadata</a>

| **Field** | **Status** |
|-----------|------------|
| bytes_html | required |
| date_modified | required |
| has_math | required |
| id | required |
| in_language | required |
| infoboxes | required |
| page_id | required |
| text | required |
| title | required |
| url | required |
| version | required |
| wikidata_id | required |
| wikiname | required |
| wikitext | required |

## <a id="languages">European Language Support</a>

FineWiki covers 325 language editions of Wikipedia. Per-language statistics are available in [counts.md](counts.md).

| **Totals** | **Documents** | **Segments** | **Tokens** | **Characters** |
|------------|--------------:|-------------:|-----------:|---------------:|
| all languages | 61,550,610 | 1,568,503,611 | 54,008,790,194 | 195,158,920,353 |

## <a id="access">Access Information</a>

The primary download site for the data is the [HuggingFace Hub](https://huggingface.co/datasets/HuggingFaceFW/finewiki).

On select EuroHPC systems, the data is directly available for read-only access on the local filesystem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/finewiki/0.0.0/data/`

## <a id="use">Terms of Use</a>

The dataset is released under the Creative Commons Attribution-ShareAlike 4.0 International License
([CC-BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)) and the GNU Free Documentation License
([GFDL](https://www.gnu.org/licenses/fdl-1.3.html)), in keeping with [Wikipedia's own licensing](https://dumps.wikimedia.org/legal.html).

### Citation Information

```bibtex
@dataset{penedo2025finewiki,
  author    = {Guilherme Penedo},
  title     = {FineWiki},
  year      = {2025},
  publisher = {Hugging Face Datasets},
  url       = {https://huggingface.co/datasets/HuggingFaceFW/finewiki},
}
```

## <a id="curator">Catalogue Curator</a>

Jindřich Helcl, University of Oslo, <jindrich@uio.no>
