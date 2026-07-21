# SwallowMath-v2

**[DRAFT] (Version 2.0; May 2026)**

## <a id="background">Background</a>

SwallowMath-v2 ([Fujii et al., 2025](https://arxiv.org/abs/2505.02881)) is a large-scale mathematical dataset developed as the successor to SwallowMath-v1. It employs an LLM-driven rewriting approach — removing boilerplate, restoring missing context, and reformatting solutions into clear, step-by-step explanations.
Additional details are available on the [HuggingFace dataset page](https://huggingface.co/datasets/tokyotech-llm/swallow-math-v2).

## <a id="sources">Data Sources</a>

Derived from [FineMath-3+](https://huggingface.co/datasets/HuggingFaceFW/finemath), a high-quality subset of mathematical content filtered from CommonCrawl. Rewritten using Qwen3-235B-A22B-2507-Instruct through a three-stage pipeline: length filtering, math text extraction, and LLM rewriting.

## <a id="statistics">Structure & Statistics</a>

The dataset is distributed as 208 uncompressed JSONlines files, amounting to 102 GB on disk.
Files are organised into two partitions: `stage3-qa` (question-answer format) and `stage3-textbook` (structured textbook-style explanations), each containing multiple shards following the naming pattern `train-NNNNN-Qwen3-235B-A22B-Thinking-2507-FP8.jsonl`.

**Record Fields**

| **Field** | **Status** |
|-----------|------------|
| `text` | required |


## <a id="languages">European Language Support</a>

SwallowMath-v2 is English-only.

| **Partition** | **Documents** | **Segments** | **Tokens** | **Length**| **Characters** |
|---------------|--------------:|-------------:|-----------:|----------:|---------------:|
| stage3-qa | 12,635,739 | 1,049,149,946 | 14,899,456,775 | 1,179.2 | 38,775,604,749 |
| stage3-textbook | 13,302,336 | 944,442,899 | 19,050,621,555 | 1,432.1 | 66,277,727,067 |
| **Total** | **25,938,075** | **1,993,592,845** | **33,950,078,330** | **1,308.9** | **105,053,331,816** |


## <a id="access">Access Information</a>

The primary download site for the data is the [HuggingFace Hub](https://huggingface.co/datasets/tokyotech-llm/swallow-math-v2).

On select EuroHPC systems, the data is directly available for read-only access on the local filesystem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/swallow-math/2.0/data/`
+ Leonardo: `/leonardo_work/OELLM_Catalog/training/swallow-math/2.0/data/`

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
