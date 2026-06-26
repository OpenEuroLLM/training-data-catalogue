# MegaMath

**[DRAFT] (Version 0.0.0; June 2026)**

## <a id="background">Background</a>

MegaMath ([Zhou et al., 2025](https://arxiv.org/abs/2504.02807)) is an open mathematics pre-training dataset curated from three complementary sources: re-extracted mathematical web text, high-quality math-related code, and synthetically generated content.
Additional details are available on the [HuggingFace dataset page](https://huggingface.co/datasets/LLM360/MegaMath).

## <a id="sources">Data Sources</a>

Three source domains:

- **Web** (`megamath-web`, `megamath-web-pro`): Mathematical documents re-extracted from [Common Crawl](https://commoncrawl.org/) using math-oriented HTML processing, fastText-based quality filtering, and deduplication. `megamath-web-pro` is a higher-quality filtered subset.
- **Code** (`megamath-code`, `megamath-translated-code`): Math-related code from [The Stack v2](https://huggingface.co/datasets/bigcode/the-stack-v2), with an additional translated-code partition.
- **Synthetic** (`megamath-qa`, `megamath-text-code-block`): QA-style text and interleaved text-code blocks synthesised from existing math content.

## <a id="statistics">Structure & Statistics</a>

The dataset is organised into six partitions, stored as Zstd-compressed JSONLines files in per-partition subdirectories.

| **Partition** | **Documents** | **Segments** | **Tokens** | **Length** | **Characters** |
|---------------|--------------:|-------------:|-----------:|-----------:|---------------:|
| megamath-code | -- | -- | -- | -- | -- |
| megamath-qa | 22,635,192 | 308,314,144 | 6,484,940,027 | 286.5 | 19,107,384,977 |
| megamath-text-code-block | 52,686,522 | 5,377,058,152 | 45,799,614,880 | 869.3 | 129,208,978,478 |
| megamath-translated-code | 7,369,794 | 747,375,211 | 6,612,961,603 | 897.3 | 22,480,485,953 |
| megamath-web | 106,470,252 | 14,836,769,252 | 232,116,662,719 | 2,180.5 | 856,227,745,369 |
| megamath-web-pro | 14,978,856 | 739,553,653 | 13,658,872,234 | 911.9 | 52,554,372,391 |
| **Total** | **204,140,616** | **22,009,070,412** | **304,673,051,463** | **1,492.4** | **1,079,578,967,168** |

Note: `megamath-code` contains only GitHub repository and file references (`file_info`/`repo_info`) rather than text content, so no text statistics are available for that partition.

## <a id="metadata">Available Metadata</a>

TODO

## <a id="languages">European Language Support</a>

MegaMath is English-only.

| **Code(s)** | **Documents** | **Segments** | **Tokens** | **Length** | **Characters** |
|-------------|--------------:|-------------:|-----------:|-----------:|---------------:|
| eng_Latn | 204,140,616 | 22,009,070,412 | 304,673,051,463 | 1,492.4 | 1,079,578,967,168 |

## <a id="access">Access Information</a>

The primary download site for the data is the [HuggingFace Hub](https://huggingface.co/datasets/LLM360/MegaMath).

On select EuroHPC systems, the data is directly available for read-only access on the local filesystem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/megamath/0.0.0/data/`
+ Leonardo: `/leonardo_work/openeurollm/training/megamath/0.0.0/data/`

## <a id="use">Terms of Use</a>

The dataset is released under the Open Data Commons Attribution License (ODC-By) v1.0 [license](https://opendatacommons.org/licenses/by/1-0/). Use of the web-derived partitions is also subject to the [Common Crawl Terms of Use](https://commoncrawl.org/terms-of-use).

### Citation information

```bibtex
@misc{zhou2025megamathpushinglimitsopen,
      title={MegaMath: Pushing the Limits of Open Math Corpora}, 
      author={Fan Zhou and Zengzhi Wang and Nikhil Ranjan and Zhoujun Cheng and Liping Tang and Guowei He and Zhengzhong Liu and Eric P. Xing},
      year={2025},
      eprint={2504.02807},
      archivePrefix={arXiv},
      primaryClass={cs.CL},
      url={https://arxiv.org/abs/2504.02807}, 
}
```

## <a id="curator">Catalogue Curator</a>

Jindřich Helcl, University of Oslo, <jindrich@uio.no>
