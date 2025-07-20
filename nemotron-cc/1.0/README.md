# Nemotron-CC

## <a id="background">Background</a>

Nemotron-CC is a 6.3T token dataset based on Common Crawl, designed to support long-horizon pretraining of language models. The data construction and preliminary experimental results of training are described in [Su et al. (2024)](https://arxiv.org/abs/2412.02595). Additional details and download instructions are available on the [Common Crawl Nemotron-CC repository](https://data.commoncrawl.org/contrib/Nemotron/Nemotron-CC/index.html).

## <a id="sources">Data Sources</a>

The Nemotron-CC dataset is a 6.3T token collection derived from the Common Crawl (CC) archives, spanning crawls from CC-MAIN-2013-20 to CC-MAIN-2024-30 (99 crawls in total). The dataset consists of 4.4T globally deduplicated original tokens and 1.9T synthetically generated tokens. Token extraction was conducted using a combination of classifier ensembling, synthetic data rephrasing, and minimal reliance on heuristic filters, ensuring a balance between data quality and quantity.

Nemotron-CC is partitioned by quality (high, medium-high, medium, medium-low, and low) and type (actual or synthetic). Synthetic tokens are further categorized into specific subtypes, including distillation, diverse question-answer pairs, knowledge extraction, and others. The dataset is formatted in both `.jsonl.zstd` and upcoming `.parquet` formats.

To ensure diversity and robustness in training, the authors have included various types of content such as instructional, educational, and knowledge-based material, which were filtered and enriched for optimal performance across long-horizon training tasks.

## <a id="statistics">Structure & Statistics</a>

Currently, the Nemotron-CC dataset is distributed in compressed `.jsonl.zstd` format, totaling approximately 10.4 TiB across multiple files. The data spans 31,279 individual files, organized by various attributes such as quality, type, and content kind. Files are divided by quality levels (high, medium-high, medium, medium-low, low), kind (actual, synthetic), and kind2 (actual, distill, diverse_qa_pairs, extract_knowledge, knowledge_list, wrap_medium).

Files are available only in the following partition combinations:

```
contrib/Nemotron/Nemotron-CC/data-jsonl/quality=high/kind=actual/kind2=actual/
contrib/Nemotron/Nemotron-CC/data-jsonl/quality=high/kind=synthetic/kind2=distill/
contrib/Nemotron/Nemotron-CC/data-jsonl/quality=high/kind=synthetic/kind2=diverse_qa_pairs/
contrib/Nemotron/Nemotron-CC/data-jsonl/quality=high/kind=synthetic/kind2=extract_knowledge/
contrib/Nemotron/Nemotron-CC/data-jsonl/quality=high/kind=synthetic/kind2=knowledge_list/
contrib/Nemotron/Nemotron-CC/data-jsonl/quality=high/kind=synthetic/kind2=wrap_medium/
contrib/Nemotron/Nemotron-CC/data-jsonl/quality=medium-high/kind=actual/kind2=actual/
contrib/Nemotron/Nemotron-CC/data-jsonl/quality=medium/kind=actual/kind2=actual/
contrib/Nemotron/Nemotron-CC/data-jsonl/quality=medium-low/kind=actual/kind2=actual/
contrib/Nemotron/Nemotron-CC/data-jsonl/quality=low/kind=actual/kind2=actual/
contrib/Nemotron/Nemotron-CC/data-jsonl/quality=low/kind=synthetic/kind2=wrap_medium/
```

For example:

One partition starts from `contrib/Nemotron/Nemotron-CC/data-jsonl/quality=high/kind=actual/kind2=actual/CC-MAIN-2013-20-part-00000.jsonl.zstd`, and ends in `contrib/Nemotron/Nemotron-CC/data-jsonl/quality=high/kind=actual/kind2=actual/CC-MAIN-2013-20-part-00042.jsonl.zstd`.

## <a id="languages">European Language Support</a>

Nemotron-CC currently only offers support for English, and contains 6.3T tokens with a total of 10.4 TiB over 31,279 individual partitions.

In the table below is shown partition examples with their respective data analysis report using HPLTAnalytics. Work is being done to analyze all Nemotron-CC partitions left.

| **Code(s)** | **Bytes** | **Documents** | **Segments** | **Tokens** | **Characters** | **Report** |
|-------------|----------:|--------------:|-------------:|-----------:|---------------:|---------------:|
|  /quality=low/kind=actual/kind2=actual/CC-MAIN-2023-14-part-00020 | 893,463,167 | 356,191 | 5,007,426 | 172,477,093 | 891,877,343 | [report](https://github.com/user-attachments/files/21312335/report.mono-nemotron-low.pdf) |
|  /quality=medium-low/kind=actual/kind2=actual/CC-MAIN-2023-14-part-00036 | 924,215,328 | 292,372 | 4,677,806 | 178,207,255 | 922,804,789 | [report](https://github.com/user-attachments/files/21312337/report.mono-nemotron-medium-low.pdf) |
|  /quality=medium/kind=actual/kind2=actual/CC-MAIN-2023-14-part-00036 | 937,479,477 | 246,875 | 4,536,463 | 180,519,004 | 936,185,016 | [report](https://github.com/user-attachments/files/21312340/report.mono-nemotron-medium.pdf) |
|  /quality=medium-high/kind=actual/kind2=actual/CC-MAIN-2023-14-part-00036 | 927,052,490 | 221,871 | 4,928,468 | 179,220,923 | 925,544,995 | [report](https://github.com/user-attachments/files/21312341/report.mono-nemotron-medium-high.pdf) |
|  /quality=high/kind=actual/kind2=actual/CC-MAIN-2023-14-part-00036 | 930,330,513 | 252,407 | 5,428,956 | 179,322,081 | 928,838,311 | [report](https://github.com/user-attachments/files/21312343/report.mono-nemotron-high.pdf) |
|  Total | 4,612,540,975 | 1,369,716 | 24579119 | 889,746,356 | 4605250454 |  |

## <a id="access">Access Information</a>

The primary download site for the data is [hosted at Common Crawl](https://data.commoncrawl.org/contrib/Nemotron/Nemotron-CC/index.html)

Additionally, on Cineca computing servers, the data is directly available for read-only access on the Leonardo work filesytem.

- Cineca Leonardo: TBD!

## <a id="use">Terms of Use</a>

See the Common Crawl website: https://commoncrawl.org/terms-of-use

## <a id="curator">Catalogue Curator</a>

Tudor Nicolae Mateiu, Prompsit Language Engineering, tudornm@prompsit.com
