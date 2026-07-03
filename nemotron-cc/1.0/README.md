# English Nemotron-CC

**[DRAFT] (Version 1.0; January 2025)**

## <a id="background">Background</a>

Nemotron-CC is a 6.3T token dataset based on Common Crawl, designed to support long-horizon pretraining of language models. The data construction and preliminary experimental results of training are described in [Su et al. (2024)](https://arxiv.org/abs/2412.02595). Additional details and download instructions are available on the [Common Crawl Nemotron-CC repository](https://data.commoncrawl.org/contrib/Nemotron/Nemotron-CC/index.html).

## <a id="sources">Data Sources</a>

The Nemotron-CC dataset is a 6.3T token collection derived from the Common Crawl (CC) archives, spanning crawls from CC-MAIN-2013-20 to CC-MAIN-2024-30 (99 crawls in total). The dataset consists of 4.4T globally deduplicated original tokens and 1.9T synthetically generated tokens. Token extraction was conducted using a combination of classifier ensembling, synthetic data rephrasing, and minimal reliance on heuristic filters, ensuring a balance between data quality and quantity.

Nemotron-CC is partitioned by quality (`high`, `medium-high`, `medium`, `medium-low`, and `low`) and type (`actual` or `synthetic`).
Synthetic tokens are further categorized into specific subtypes, including distillation, diverse question-answer pairs, knowledge extraction, and others.

To ensure diversity and robustness in training, the authors have included various types of content such as instructional, educational, and knowledge-based material, which were filtered and enriched for optimal performance across long-horizon training tasks.

## <a id="statistics">Structure & Statistics</a>

Currently, the Nemotron-CC dataset is distributed in compressed `.jsonl.zstd` format, totaling approximately 10.4 TiB across multiple files.
The data spans 31,279 individual files, organized by various attributes such as quality, kind, and more specific sub-kind (for synthetic data only).
Not all possible combinations of this three-way categorization are instantiated, however, where each available category is called a “partition” of Nemotron-CC and organized as a directory tree as indicated in the table below (for a total of 11 partitions, of which six provide synthetic data).


## <a id="languages">European Language Support</a>

Nemotron-CC currently only offers support for English, and contains 6.3T tokens with a total of 10.4 TiB over 31,279 individual partitions.

| **Partition** | **Bytes** | **Documents** | **Segments** | **Tokens** | **Characters** |
|---------------|----------:|--------------:|-------------:|-----------:|---------------:|
| `high/actual` | 985,207,328,133 | 746,497,814 | 24,931,625,420 | 547,386,548,541 | 2,542,157,250,740 |
| `medium-high/actual` | 891,052,544,451 | 558,672,867 | 20,746,893,744 | 498,856,066,341 | 2,281,743,277,714 |
| `medium/actual` | 3,642,566,722,294 | 2,283,946,116 | 78,726,811,347 | 1,999,585,502,136 | 9,120,571,332,539 |
| `medium-low/actual` | 1,645,253,176,637 | 1,303,763,743 | 36,100,836,483 | 880,389,991,885 | 3,965,319,106,017 |
| `low/actual` | 741,314,138,964 | 886,051,765 | 19,474,142,468 | 393,072,591,326 | 1,736,485,933,124 |
| `high/synthetic/distill` | 330,034,560,739 | 625,084,757 | 4,514,122,171 | 154,525,280,867 | 773,448,286,117 |
| `high/synthetic/diverse_qa_pairs` | 870,117,750,117 | 971,926,311 | 14,418,536,749 | 494,948,804,759 | 2,328,110,126,792 |
| `high/synthetic/extract_knowledge` | 575,919,231,431 | 719,847,367 | 12,020,475,260 | 296,547,970,089 | 1,503,940,800,794 |
| `high/synthetic/knowledge_list` | 393,501,193,476 | 831,788,979 | 11,949,341,548 | 201,892,185,052 | 932,061,750,430 |
| `high/synthetic/wrap_medium` | 711,629,317,209 | 539,330,534 | 10,707,362,328 | 363,982,920,727 | 1,858,588,569,551 |
| `low/synthetic/wrap_medium` | 646,016,695,389 | 881,905,297 | 8,999,131,968 | 325,499,263,575 | 1,575,896,887,357 |
| **Total** | **11,432,612,658,840** | **10,348,815,550** | **242,589,279,486** | **6,156,687,125,298** | **28,618,323,321,175** |

## <a id="access">Access Information</a>

The primary download site for the data is [hosted at Common Crawl](https://data.commoncrawl.org/contrib/Nemotron/Nemotron-CC/index.html)

On select EuroHPC systems, the data is directly available for read-only access on the local filesytem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/nemotron-cc/1.0/`
+ Leonardo: `/leonardo_work/OELLM_Catalog/training/nemotron-cc/1.0/`

## <a id="use">Terms of Use</a>

See the Common Crawl website: https://commoncrawl.org/terms-of-use

## <a id="curator">Catalogue Curator</a>

Tudor Nicolae Mateiu, Prompsit Language Engineering, tudornm@prompsit.com
