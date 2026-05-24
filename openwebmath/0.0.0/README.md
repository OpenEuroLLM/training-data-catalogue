# OpenWebMath

**[DRAFT] (Version 0.0.0; May 2026)**

## <a id="background">Background</a>

OpenWebMath ([Paster et al., 2023](https://arxiv.org/abs/2310.06786)) is a dataset of high-quality mathematical web text extracted from Common Crawl. It covers mathematics, physics, statistics, and computer science across 130,000+ domains, filtered from over 200 billion HTML files.
Details are available on the [HuggingFace dataset page](https://huggingface.co/datasets/open-web-math/open-web-math).

## <a id="sources">Data Sources</a>

[Common Crawl](https://commoncrawl.org/).

## <a id="statistics">Structure & Statistics</a>

The dataset is distributed as 114 Parquet files in a single `train` split.

| **Partition** | **Bytes** | **Documents** | **Segments** | **Tokens** | **Characters** |
|-------------|----------:|--------------:|-------------:|-----------:|---------------:|
| data | 15,389,971,895 | 6,315,233 | 565,154,308 | 13,307,862,086 | 48,737,242,606 |
| **Total** | 15,389,971,895 | 6,315,233 | 565,154,308 | 13,307,862,086 | 48,737,242,606 |

## <a id="metadata">Available Metadata</a>

| **Field** | **Status** |
|-----------|------------|
| date | required |
| metadata | required |
| text | required |
| url | required |

## <a id="languages">European Language Support</a>

OpenWebMath is English-only.

| **Code(s)** | **Documents** | **Segments** | **Tokens** | **Length** | **Characters** |
|-------------|--------------:|-------------:|-----------:|-----------:|---------------:|
| eng_Latn | 6,315,233 | 565,154,308 | 13,307,862,086 | 2,107.3 | 48,737,242,606 |

## <a id="access">Access Information</a>

The primary download site for the data is the [HuggingFace Hub](https://huggingface.co/datasets/open-web-math/open-web-math).

On select EuroHPC systems, the data is directly available for read-only access on the local filesystem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/open-web-math/0.0.0/data/`

## <a id="use">Terms of Use</a>

The dataset is released under the Open Data Commons Attribution License (ODC-By) v1.0 [license](https://opendatacommons.org/licenses/by/1-0/). Use is also subject to the [Common Crawl Terms of Use](https://commoncrawl.org/terms-of-use).

### Citation information

```bibtex
@misc{paster2023openwebmath,
      title={OpenWebMath: An Open Dataset of High-Quality Mathematical Web Text},
      author={Keiran Paster and Marco Dos Santos and Zhangir Azerbayev and Jimmy Ba},
      year={2023},
      eprint={2310.06786},
      archivePrefix={arXiv},
      primaryClass={cs.AI}
}
```

## <a id="curator">Catalogue Curator</a>

Jindřich Helcl, University of Oslo, <jindrich@uio.no>
