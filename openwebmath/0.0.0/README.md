# OpenWebMath

**[DRAFT] (Version 0.0.0; May 2026)**

## <a id="background">Background</a>

OpenWebMath ([Paster et al., 2023](https://arxiv.org/abs/2310.06786)) is a dataset of high-quality mathematical web text extracted from Common Crawl. It covers mathematics, physics, statistics, and computer science across 130,000+ domains, filtered from over 200 billion HTML files.
Additional details are available on the [Hugging Face dataset page](https://huggingface.co/datasets/open-web-math/open-web-math).

## <a id="sources">Data Sources</a>

[Common Crawl](https://commoncrawl.org/).
Text and LaTeX were extracted with boilerplate removal, then filtered for English, mathematical content (a custom MathScore model), and quality (KenLM perplexity), followed by SimHash deduplication.

## <a id="statistics">Structure & Statistics</a>

The dataset is distributed as 114 Zstd-compressed JSONlines files, amounting to 15 GB on disk.
Files are stored flat in the `data` directory and follow the naming pattern `train-NNNNN-of-00114-<hash>.jsonl.zst`.

**Record Fields**

| **Field** | **Status** |
|-----------|------------|
| `date` | required |
| `metadata` | required |
| `text` | required |
| `url` | required |

## <a id="languages">European Language Support</a>

OpenWebMath is English-only.

| **Code(s)** | **Documents** | **Segments** | **Tokens** | **Length** | **Characters** |
|-------------|--------------:|-------------:|-----------:|-----------:|---------------:|
| eng_Latn | 6,315,233 | 565,154,308 | 13,307,862,086 | 2,107.3 | 48,737,242,606 |

## <a id="access">Access Information</a>

The primary download site for the data is the [Hugging Face Hub](https://huggingface.co/datasets/open-web-math/open-web-math).

On select EuroHPC systems, the data is directly available for read-only access on the local filesystem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/open-web-math/0.0.0/data/`
+ Leonardo: `/leonardo_work/OELLM_Catalog/training/open-web-math/0.0.0/data/`

## <a id="use">Terms of Use</a>

The dataset is released under the Open Data Commons Attribution License (ODC-By) v1.0 [license](https://opendatacommons.org/licenses/by/1-0/). Use is also subject to the [Common Crawl Terms of Use](https://commoncrawl.org/terms-of-use).

## <a id="citation">References</a>

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
