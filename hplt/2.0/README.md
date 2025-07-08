# HPLT Monolingual Datasets (Version 2.0; of September 2024)

## <a id="background">Background</a>

The HPLT Monolingual Datasets 2.0 aim to provide large volumes of high-quality running text with strong multilingual emphasis.
The data construction and preliminary experimental results are described by [Burchell, et al., 2025](https://arxiv.org/abs/2503.10267), to appear in the Proceedings of the Annual Conference of the Association for Computational Linguistics.
Additional details and download instructions are available from the [HPLT download site](https://hplt-project.org/datasets/v2.0).

## <a id="sources">Data Sources</a>

This dataset is comprised of text derived from web crawls, predominantly so-called wide crawls conducted by the Internet Archive (IA) between 2012 and 2020 (some 3.5 pib in raw data), complemented with a smaller portion of Common Crawl (CC) data from between 2014 and 2023 (some 750 tib).
HTML documents and metadata were extracted using the [warc2text](https://github.com/bitextor/warc2text) tool, and subsequently ‘main content’ text was extracted using the [Trafilatura](https://github.com/adbar/trafilatura) library.
Language identification for a total of 193 distinct language codes was performed with [OpenLID](https://github.com/laurieburchell/open-lid-dataset).
Additional metadata enrichment and quality-oriented filtering are applied through the [Monotextor](https://github.com/hplt-project/monotextor-slurm) pipeline.

The dataset is internally organized into so-called collections, corresponding to either one full calendar year of CC crawls, or one complete IA crawl.
HPLT has released two variants, called _deduplicated_ and _cleaned_, where the former is larger and only reflects collection-internal near-deduplication (using MinHash).
The _cleaned_ variant has undergone additional enrichment, including segment-level language identification and quality estimation by [Web Docs Scorer](https://github.com/pablop16n/web-docs-scorer/blob/main/README.md) (WDS), and heuristic filtering.

## <a id="statistics">Key Statistics</a>

The _cleaned_ version is distributed as 605 compressed JSONlines files, amounting to a total of about 15 tib on disk.
For larger languages, the data is distributed across multiple files, e.g. `eng_Latn/1.jsonl.zst` … `eng_Latn/160.jsonl.zst` for the 160 parts that jointly comprise some 3,4 billion documents identified as English.
When sampling subsets of the data, it may be advisable to give preference to documents with higher WDS quality estimates, i.e. the first value in the JSON `doc_scores` field.

## <a id="languages">European Language Support</a>

| **Code(s)** | **Bytes** | **Documents** | **Segments** | **Tokens** | **Characters** |
|-------------|----------:|--------------:|-------------:|-----------:|---------------:|
|  [bul_Cyrl](https://analytics.hplt-project.org/viewer/HPLT-v2-bul_Cyrl.yaml) | 44,283,861,975 | 28,087,181 | 681,406,236 | 32,855,326,157 | 96,934,273,361 |
|  [ces_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-ces_Latn.yaml) | 109,711,940,916 | 75,288,021 | 1,926,503,033 | 95,363,069,335 | 273,936,688,894 |
|  [dan_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-dan_Latn.yaml) | 46,874,204,383 | 33,841,408 | 873,022,625 | 41,156,519,209 | 133,380,682,616 |
|  deu_Latn | 643,563,226,429 | 482,053,407 | 11,127,774,286 | 449,431,582,918 | 1,782,129,825,333 |
|  ell_Grek | 125,752,059,355 | 70,328,890 | 1,849,481,662 | 115,599,058,101 | 283,534,611,644 |
|  eng_Latn | 6,199,414,043,792 | 4,388,525,961 | 116,521,950,325 | 3,915,588,774,525 | 17,083,161,859,947 |
|  [est_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-est_Latn.yaml) | 13,143,473,236 | 8,449,320 | 264,422,814 | 12,324,211,253 | 36,018,221,232 |
|  [fin_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-fin_Latn.yaml) | 55,164,578,152 | 34,815,601 | 976,622,086 | 53,580,820,308 | 155,678,802,052 |
|  fra_Latn | 528,153,012,485 | 401,831,660 | 10,557,148,321 | 379,038,708,184 | 1,457,428,851,611 |
|  [gle_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-gle_Latn.yaml) | 608,544,067 | 490,787 | 10,993,158 | 643,453,119 | 1,749,350,336 |
|  [hrv_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-hrv_Latn.yaml) | 18,455,135,510 | 12,303,820 | 297,132,744 | 15,377,672,465 | 47,995,473,960 |
|  [hun_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-hun_Latn.yaml) | 84,104,083,079 | 51,870,492 | 1,418,772,876 | 79,082,122,145 | 225,200,264,565 |
|  [ita_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-ita_Latn.yaml) | 298,427,404,410 | 221,752,424 | 5,127,292,899 | 213,754,351,761 | 820,602,938,696 |
|  [ltg_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-ltg_Latn.yaml) [lvs_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-nob_lvs.yaml) | 9,240,310,207 | 6,780,843 | 173,958,974 | 9,777,313,720 | 25,209,419,142 |
|  [lit_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-lit_Latn.yaml) | 18,792,388,046 | 13,338,275 | 322,156,374 | 17,999,481,637 | 50,393,738,585 |
|  [mlt_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-mlt_Latn.yaml) | 473,820,795 | 367,265 | 8,675,475 | 570,825,363 | 1,441,648,250 |
|  nld_Latn | 163,348,254,430 | 138,651,084 | 3,074,592,386 | 122,628,893,009 | 451,077,252,328 |
|  pol_Latn | 235,852,448,102 | 175,410,669 | 4,460,832,917 | 196,052,655,218 | 631,594,269,186 |
|  por_Latn | 322,955,910,917 | 237,812,825 | 6,124,611,786 | 233,189,157,063 | 896,547,444,407 |
|  [ron_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-ron_Latn.yaml) | 92,755,690,867 | 65,876,383 | 1,696,970,479 | 76,264,228,246 | 250,658,132,448 |
|  [slk_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-slk_Latn.yaml) | 28,347,675,196 | 21,827,259 | 494,278,579 | 24,504,432,765 | 70,372,196,449 |
|  [slv_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-slv_Latn.yaml) | 13,480,602,614 | 10,277,173 | 238,644,943 | 11,867,536,246 | 35,258,183,993 |
|  spa_Latn | 696,098,726,982 | 503,073,098 | 12,121,752,157 | 471,218,993,500 | 1,953,862,248,952 |
|  [swe_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-swe_Latn.yaml) | 93,095,597,524 | 66,812,562 | 1,754,677,064 | 75,784,600,156 | 251,109,959,822 |
|  [cat_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-cat_Latn.yaml) | 22,164,638,576 | 18,553,883 | 383,335,831 | 18,116,292,562 | 60,186,591,495 |
|  [eus_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-eus_Latn.yaml) | 2,187,606,572 | 1,974,218 | 37,621,611 | 2,034,478,450 | 6,052,165,410 |
|  [glg_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-glg_Latn.yaml) | 3,677,366,325 | 3,020,164 | 61,177,888 | 2,736,491,963 | 10,108,660,186 |
|  [bos_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-bos_Latn.yaml) | 18,404,991,480 | 14,613,088 | 268,156,648 | 14,828,824,339 | 46,070,953,520 |
|  [isl_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-isl_Latn.yaml) | 3,658,429,281 | 2,840,735 | 69,643,257 | 3,835,365,590 | 9,593,246,968 |
|  [kat_Geor](https://analytics.hplt-project.org/viewer/HPLT-v2-kat_Geor.yaml) | 5,248,761,917 | 3,335,164 | 63,722,098 | 4,538,769,891 | 10,155,612,392 |
|  [mkd_Cyrl](https://analytics.hplt-project.org/viewer/HPLT-v2-mkd_Cyrl.yaml) | 4,353,674,682 | 3,565,647 | 57,008,331 | 3,406,651,991 | 9,439,624,767 |
|  [als_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-als_Latn.yaml) | 6,144,592,594 | 5,385,262 | 95,101,980 | 5,892,424,412 | 16,095,653,237 |
|  [srp_Cyrl](https://analytics.hplt-project.org/viewer/HPLT-v2-srp_Cyrl.yaml) | 7,691,997,099 | 4,123,458 | 93,809,457 | 6,106,504,834 | 16,156,879,041 |
|  tur_Latn | 105,086,134,521 | 84,541,414 | 1,941,885,324 | 85,625,744,754 | 283,639,575,889 |
|  [ukr_Cyrl](https://analytics.hplt-project.org/viewer/HPLT-v2-ukr_Cyrl.yaml) | 83,197,910,551 | 47,395,787 | 1,169,038,372 | 60,690,550,123 | 182,867,693,190 |
|  [nno_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-nno_Latn.yaml) [nob_Latn](https://analytics.hplt-project.org/viewer/HPLT-v2-nob_Latn.yaml) | 51,074,925,109 | 28,476,988 | 710,577,489 | 42,080,040,980 | 138,648,073,341 |
| Total | 10,154,988,022,176 | 7,267,692,216 | 187,054,752,485 | 6,893,545,926,292 | 27,804,291,067,245 |

## <a id="access">Access Information</a>

The primary [download site](https://hplt-project.org/datasets/v2.0) for the data is hosted at the Norwegian national [NIRD](https://documentation.sigma2.no/files_storage/nird_lmd.html) research data infrastructure, which offers premium connectivity to the Europen research data network.
For convenience, selected subsets of the data have also been ingested to the [Hugging Face Hub](https://huggingface.co/datasets/HPLT/HPLT2.0_cleaned).

On select EuroHPC systems, the data is directly available for read-only access on the local filesytem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/hplt/2.0/`

## <a id="use">Terms of Use</a>

The HPLT terms of use distinguish between the _collection_ and the _textual content_, where the first comprises the organization of the data and all metadata, and the latter the actual strings (the values of the JSON `text` fields) extracted from the original web documents.
The collection is licensed under [Creative Commons Public Domain (CC0)](https://creativecommons.org/share-your-work/public-domain/cc0/) terms, whereas neither HPLT nor the original crawlers (IA and CC) hold rights to the textual content.
HPLT has filtered out data that at the time of crawling likely was subject to standard opt-out procedures (the `robots.txt` protocol).
A take-down mechanism is offered through the above download site.
Users need to make sure that use of the data complies with any applicable legal framework, such as, among others, the EU Copyright Directive 2019/790 and the General Data Protection Regulation 2018, as amended.

## <a id="curator">Catalogue Curator</a>

Stephan Oepen, University of Oslo, <oe@ifi.uio.no>
