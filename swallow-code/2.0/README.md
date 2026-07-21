# SwallowCode-v2

**[DRAFT] (Version 2.0; May 2026)**

## <a id="background">Background</a>

SwallowCode-v2 ([Fujii et al., 2025](https://arxiv.org/abs/2505.02881)) is a synthetic Python code dataset. All samples are auto-formatted, style-normalized, and enhanced for algorithmic clarity via an LLM rewriting pipeline.
Additional details are available on the [Hugging Face dataset page](https://huggingface.co/datasets/tokyotech-llm/swallow-code-v2).

## <a id="sources">Data Sources</a>

Derived from quality-filtered [The-Stack-v2](https://huggingface.co/datasets/bigcode/the-stack-v2), rewritten using Qwen3-235B-A22B-Instruct through a five-stage pipeline resulting in LLM rewriting and auto-formatting.

## <a id="statistics">Structure & Statistics</a>

The dataset is distributed as 150 uncompressed JSONlines files. For the catalogue internal uniformity, the files were Zstd-compressed, amounting to 100 GB on disk.
There is a sole internal part stored under `stage5-auto-format/python/medium/`. The individual data files follow the naming pattern `train_NNNN.jsonl.zst`.

<details>
<summary><b>Record Fields</b></summary>

| **Field** | **Status** |
|-----------|------------|
| `Qwen3-14B_evaluation` | required |
| `auto_fix_output` | required |
| `blob_id` | required |
| `branch_name` | required |
| `committer_date` | required |
| `content_id` | required |
| `detected_licenses` | required |
| `directory_id` | required |
| `extension` | required |
| `fork_events_count` | required |
| `gha_created_at` | required |
| `gha_event_created_at` | required |
| `gha_language` | required |
| `gha_license_id` | required |
| `github_id` | required |
| `improved_code` | required |
| `improved_text` | required |
| `is_generated` | required |
| `is_vendor` | required |
| `language` | required |
| `length_bytes` | required |
| `license_type` | required |
| `lint_report` | required |
| `old_text` | required |
| `path` | required |
| `repo_name` | required |
| `revision_date` | required |
| `revision_id` | required |
| `score` | required |
| `snapshot_id` | required |
| `src_encoding` | required |
| `star_events_count` | required |
| `text` | required |
| `visit_date` | required |

</details>

## <a id="languages">European Language Support</a>

All content is LLM-generated Python code.

| **Language** | **Documents** | **Segments** | **Tokens** | **Length** | **Characters** |
|-------------|--------------:|-------------:|-----------:|-----------:|---------------:|
| Python  | 28,705,016 | 6,615,526,926 | 59,110,824,658 | 2,059.3 | 216,822,734,139 |


## <a id="access">Access Information</a>

The primary download site for the data is the [Hugging Face Hub](https://huggingface.co/datasets/tokyotech-llm/swallow-code-v2).

On select EuroHPC systems, the data is directly available for read-only access on the local filesystem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/swallow-code/2.0/data/`
+ Leonardo: `/leonardo_work/OELLM_Catalog/training/swallow-code/2.0/data/`

## <a id="use">Terms of Use</a>

The dataset is released under the [Apache-2.0 License](https://www.apache.org/licenses/LICENSE-2.0).

## <a id="citation">References</a>

```bibtex
@misc{fujii2025rewritingpretrainingdataboosts,
      title={Rewriting Pre-Training Data Boosts LLM Performance in Math and Code},
      author={Kazuki Fujii and Yukito Tajima and Sakae Mizuki and Hinari Shimada and Taihei Shiotani and Koshiro Saito and Masanari Ohi and Masaki Kawamura and Taishi Nakamura and Takumi Okamoto and Shigeki Ishida and Kakeru Hattori and Youmi Ma and Hiroya Takamura and Rio Yokota and Naoaki Okazaki},
      year={2025},
      eprint={2505.02881},
      archivePrefix={arXiv},
      primaryClass={cs.LG},
}
```

## <a id="curator">Catalogue Curator</a>

Jindřich Helcl, University of Oslo, <jindrich@uio.no>
