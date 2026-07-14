# Multilingual C4

**[DRAFT] (Version 3.1.0; July 2026)**

## <a id="background">Background</a>

Multilingual C4 (mC4) is a large-scale multilingual web text corpus derived from Common Crawl, covering 108 languages. It was created as part of the mT5 project ([Xue et al., 2021](https://arxiv.org/abs/2010.11934)) and is distributed by the Allen Institute for AI as part of the broader [C4 dataset](https://huggingface.co/datasets/allenai/c4), which also includes English-only and filtered variants. The multilingual variant is intended for multilingual LLM pretraining.
Additional details are available on the [HuggingFace dataset page](https://huggingface.co/datasets/allenai/c4).

## <a id="sources">Data Sources</a>

[Common Crawl](https://commoncrawl.org/). Text was extracted and filtered using heuristics adapted from the original C4 pipeline: removal of lines not ending in terminal punctuation, deduplication of three-sentence spans, language identification using CLD3, and removal of pages containing profanity or Lorem Ipsum placeholder text.

## <a id="statistics">Structure & Statistics</a>

The dataset is distributed as 9,010 gzip-compressed JSON files, named following the pattern `c4-<lang>.NNNNN-NNNNN-...-NNNNN.json.gz`, amounting to 14TiB on disk.
The data is organized into per-language subdirectories under `openeurollm/`, containing symlinks to the source files in `multilingual/`. 
The `openeurollm/` subset covers 35 languages and comprises 5,300 files, making up 8.7TiB of data out of the total.

**Record Fields**

| **Field** | **Status** |
|-----------|------------|
| `added` | required |
| `id` | required |
| `lang` | required |
| `metadata` | required |
| `source` | required |
| `text` | required |
| `timestamp` | required |

## <a id="languages">European Language Support</a>

| **Code(s)** | **Documents** | **Segments** | **Tokens** | **Length** | **Characters** |
|-------------|--------------:|-------------:|-----------:|-----------:|---------------:|
| bul_Cyrl | 32,511,350 | 632,428,220 | 34,893,588,514 | 1,073.3 | 99,194,413,706 |
| cat_Latn | 19,438,615 | 310,355,589 | 17,090,013,735 | 879.2 | 55,372,704,843 |
| ces_Latn | 82,262,079 | 1,502,449,922 | 85,430,501,927 | 1,038.5 | 236,167,230,380 |
| dan_Latn | 36,884,558 | 734,001,556 | 41,205,795,372 | 1,117.2 | 131,804,727,765 |
| deu_Latn | 545,956,997 | 10,028,141,918 | 482,365,064,447 | 883.5 | 1,798,835,261,831 |
| ell_Grek | 68,577,376 | 931,947,299 | 68,118,835,235 | 993.3 | 166,281,995,810 |
| eng_Latn | 3,928,733,374 | 67,855,487,188 | 3,361,807,566,026 | 855.7 | 13,391,050,949,541 |
| est_Latn | 10,401,882 | 254,910,150 | 14,665,569,663 | 1,409.9 | 42,339,878,445 |
| eus_Latn | 2,077,113 | 38,490,065 | 2,170,963,282 | 1,045.2 | 6,264,702,249 |
| fin_Latn | 36,807,562 | 716,397,351 | 41,972,232,330 | 1,140.3 | 119,897,913,577 |
| fra_Latn | 454,229,019 | 8,656,711,886 | 394,612,062,479 | 868.8 | 1,432,105,650,791 |
| gle_Latn | 611,457 | 13,903,293 | 796,570,947 | 1,302.7 | 2,112,387,710 |
| glg_Latn | 3,762,255 | 52,276,379 | 2,478,127,901 | 658.7 | 8,813,230,326 |
| hun_Latn | 56,645,732 | 1,025,646,368 | 66,549,730,780 | 1,174.8 | 185,215,535,872 |
| isl_Latn | 3,139,312 | 75,140,704 | 5,481,274,725 | 1,746.0 | 13,899,190,516 |
| ita_Latn | 267,686,115 | 4,143,513,157 | 211,316,194,864 | 789.4 | 779,139,653,265 |
| kat_Geor | 3,726,808 | 62,251,224 | 4,623,524,793 | 1,240.6 | 10,346,772,119 |
| lav_Latn | 9,882,376 | 224,308,157 | 15,022,957,580 | 1,520.2 | 38,496,048,086 |
| lit_Latn | 18,234,466 | 366,268,305 | 22,970,482,826 | 1,259.7 | 62,682,041,523 |
| mkd_Cyrl | 3,599,707 | 55,738,550 | 3,517,222,626 | 977.1 | 9,504,552,362 |
| mlt_Latn | 1,109,191 | 28,516,398 | 2,793,123,681 | 2,518.2 | 5,169,594,600 |
| nld_Latn | 136,379,427 | 2,205,864,654 | 105,507,164,676 | 773.6 | 371,091,641,765 |
| nor_Latn | 30,644,684 | 624,047,652 | 36,531,124,419 | 1,192.1 | 115,903,358,379 |
| pol_Latn | 178,690,573 | 3,235,217,787 | 173,610,062,615 | 971.6 | 527,028,294,015 |
| por_Latn | 246,401,954 | 3,864,174,941 | 178,007,688,265 | 722.4 | 657,652,623,548 |
| ron_Latn | 66,499,899 | 1,266,014,757 | 76,775,085,588 | 1,154.5 | 249,557,692,006 |
| slk_Latn | 26,721,250 | 517,078,647 | 28,643,093,914 | 1,071.9 | 78,860,084,982 |
| slv_Latn | 12,381,886 | 282,594,703 | 16,030,630,702 | 1,294.7 | 46,676,360,041 |
| spa_Latn | 591,272,118 | 10,791,666,453 | 519,991,232,250 | 879.4 | 2,051,150,708,301 |
| sqi_Latn | 7,023,573 | 104,804,659 | 6,737,150,358 | 959.2 | 18,254,318,620 |
| srp_Cyrl | 4,775,217 | 106,006,921 | 6,874,807,489 | 1,439.7 | 17,999,808,420 |
| swe_Latn | 63,308,307 | 1,175,060,992 | 62,638,897,232 | 989.4 | 201,062,698,681 |
| tur_Latn | 132,662,955 | 1,950,621,172 | 108,065,414,296 | 814.6 | 349,334,639,877 |
| ukr_Cyrl | 56,159,593 | 1,025,854,349 | 59,723,333,167 | 1,063.5 | 170,554,171,487 |
| **Total** | **7,139,198,780** | **124,857,891,366** | **6,259,017,088,704** | **876.7** | **23,449,820,835,439** |

## <a id="access">Access Information</a>

The primary download site for the data is the [HuggingFace Hub](https://huggingface.co/datasets/allenai/c4).

On select EuroHPC systems, the data is directly available for read-only access on the local filesystem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/c4/3.1.0/openeurollm/`
+ Leonardo: `/leonardo_work/OELLM_Catalog/training/c4/3.1.0/openeurollm/`

## <a id="use">Terms of Use</a>

The dataset is released under the Open Data Commons Attribution License (ODC-By) v1.0 [license](https://opendatacommons.org/licenses/by/1-0/). Use is also subject to the [Common Crawl Terms of Use](https://commoncrawl.org/terms-of-use).

### Citation information

```bibtex
@article{xue-etal-2021-mt5,
    title = "m{T}5: A Massively Multilingual Pre-Trained Text-to-Text Transformer",
    author = "Xue, Linting and Constant, Noah and Roberts, Adam and Kale, Mihir and Al-Rfou, Rami and Siddhant, Aditya and Barua, Aditya and Raffel, Colin",
    journal = "Proceedings of the 2021 Conference of the North American Chapter of the Association for Computational Linguistics: Human Language Technologies",
    year = "2021",
    pages = "483--498",
}
```

## <a id="curator">Catalogue Curator</a>

Jindřich Helcl, University of Oslo, <jindrich@uio.no>
