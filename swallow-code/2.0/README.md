# SwallowCode-v2

**[DRAFT] (Version 2.0; May 2026)**

## <a id="background">Background</a>

SwallowCode-v2 ([Fujii et al., 2025](https://arxiv.org/abs/2505.02881)) is a 49.8 billion-token Apache-2.0-licensed Python code dataset rewritten from The-Stack-v2, designed for scalable LLM pre-training. All samples are auto-formatted, style-normalized, and enhanced for algorithmic clarity via an LLM rewriting pipeline.
Additional details are available on the [HuggingFace dataset page](https://huggingface.co/datasets/tokyotech-llm/swallow-code-v2).

## <a id="sources">Data Sources</a>

Derived from [The-Stack-v2](https://huggingface.co/datasets/bigcode/the-stack-v2), rewritten using Qwen3-235B-A22B-Instruct through a five-stage pipeline culminating in LLM rewriting and auto-formatting with the ruff formatter.

## <a id="statistics">Structure & Statistics</a>

The dataset is distributed as 150 uncompressed JSONlines files, amounting to 889 GB on disk.
Files are stored under `stage5-auto-format/python/medium/` and follow the naming pattern `train_NNNN.jsonl`.

| **Partition** | **Bytes** | **Documents** | **Segments** | **Tokens** | **Characters** |
|---------------|-----------:|--------------:|-------------:|-----------:|---------------:|
| **Total** | **953,666,999,988** | **28,705,016** | **6,615,526,926** | **59,110,824,658** | **216,822,734,139** |

## <a id="languages">European Language Support</a>

SwallowCode-v2 is Python code (English).

| **Code(s)** | **Documents** | **Segments** | **Tokens** | **Characters** |
|-------------|--------------:|-------------:|-----------:|---------------:|
| **English** | 28,705,016 | 6,615,526,926 | 59,110,824,658 | 216,822,734,139 |

## <a id="access">Access Information</a>

The primary download site for the data is the [HuggingFace Hub](https://huggingface.co/datasets/tokyotech-llm/swallow-code-v2).

On select EuroHPC systems, the data is directly available for read-only access on the local filesystem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/swallow-code/2.0/data/`

## <a id="use">Terms of Use</a>

The dataset is released under the [Apache-2.0 License](https://www.apache.org/licenses/LICENSE-2.0).

### Citation information

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
