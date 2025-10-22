# Multilingual MADLAD-400

**[DRAFT] (Version 1.0; October 2021)**

## <a id="background">Background</a>

MADLAD-400 is a 3T token dataset based on Common Crawl containing 419 languages, designed to encompass a larger amount of languages than other datasets created using similar methods.
The data construction and preliminary experimental results of training are described in [Kudugunta et al. (2023)](https://arxiv.org/abs/2309.04662).
Additional details and download instructions are available on the [HuggingFace MADLAD-400 repository](https://huggingface.co/datasets/allenai/MADLAD-400).

## <a id="sources">Data Sources</a>

The MADLAD-400 dataset is a document-level multilingual dataset derived from Common Crawl (CC).
The dataset is available in two deduplicated versions: a 5T token “noisy” dataset and a 3T token “clean” dataset.
The 5T dataset is obtained directly from CC, before applying document-level LangID and any specific filtering.
On the other hand, the 3T dataset is obtained by filtering with preliminary preprocessing steps, by training and applying a semi-supervised language identification model, by filtering out questionable content, and by applying three additional filters based on language and their “self-audit” quality review.

Additionally, each dataset is released in both a document-level form and a sentence-level form.

## <a id="statistics">Structure & Statistics</a>

Currently, the MADLAD-400 dataset is distributed in compressed `.jsonl.gz` format.

## <a id="languages">European Language Support</a>

| **Code(s)** | **Bytes** | **Documents** | **Segments** | **Tokens** | **Characters** |
|-------------|----------:|--------------:|-------------:|-----------:|---------------:|
|  bul_Cyrl | 27,907,971,555 | 12,755,329 | 12,755,329 | 19,489,755,290 | 57,828,623,862 |
|  ces_Latn | 66,705,107,362 | 38,254,671 | 38,254,671 | 50,851,804,344 | 147,891,897,647 |
|  dan_Latn | 31,536,598,170 | 17,865,888 | 17,865,888 | 24,933,594,934 | 83,083,948,094 |
|  deu_Latn | 397,875,908,307 | 225,111,495 | 225,111,495 | 252,228,862,830 | 1,009,466,023,318 |
|  ell_Grek | 40,700,946,575 | 20,932,239 | 20,932,239 | 31,798,629,582 | 80,937,608,560 |
|  eng_Latn | 2,852,473,204,094 | 1,528,918,474 | 1,528,918,474 | 1,681,401,607,318 | 7,442,380,691,991 |
|  est_Latn | 11,448,538,387 | 5,542,933 | 5,542,933 | 9,721,783,976 | 28,682,517,462 |
|  fin_Latn | 40,387,493,033 | 20,433,664 | 20,433,664 | 34,201,262,623 | 101,061,286,660 |
|  fra_Latn | 397,670,709,146 | 216,945,532 | 216,945,532 | 269,040,813,325 | 1,035,390,241,419 |
|  gle_Latn | 524,972,573 | 285,999 | 285,999 | 519,239,773 | 1,409,195,138 |
|  hrv_Latn | 4,025,592,773 | 2,841,400 | 2,841,400 | 3,065,365,777 | 9,598,383,639 |
|  hun_Latn | 57,486,030,268 | 29,677,075 | 29,677,075 | 46,370,503,350 | 134,919,754,643 |
|  ita_Latn | 213,045,068,894 | 126,406,256 | 126,406,256 | 141,033,815,308 | 553,099,788,690 |
|  lav_Latn | 9,729,840,268 | 5,007,982 | 5,007,982 | 9,200,513,017 | 23,908,350,853 |
|  lit_Latn | 16,896,415,324 | 8,748,025 | 8,748,025 | 14,590,832,555 | 41,272,592,571 |
|  mlt_Latn | 490,125,225 | 265,388 | 265,388 | 539,311,594 | 1,343,837,424 |
|  nld_Latn | 126,920,755,337 | 86,594,116 | 86,594,116 | 91,087,694,983 | 334,538,938,666 |
|  pol_Latn | 151,023,303,278 | 90,908,786 | 90,908,786 | 111,112,599,813 | 356,352,714,277 |
|  por_Latn | 196,599,817,026 | 124,207,090 | 124,207,090 | 127,079,774,190 | 499,798,407,634 |
|  ron_Latn | 59,579,987,802 | 35,397,563 | 35,397,563 | 44,698,078,125 | 148,161,405,070 |
|  slk_Latn | 20,221,970,561 | 11,857,945 | 11,857,945 | 15,828,510,566 | 45,655,828,920 |
|  slv_Latn | 12,329,844,266 | 6,310,419 | 6,310,419 | 10,247,956,241 | 30,539,910,053 |
|  spa_Latn | 409,027,716,431 | 250,906,994 | 250,906,994 | 254,750,449,059 | 1,063,143,461,628 |
|  swe_Latn | 61,164,238,851 | 35,153,050 | 35,153,050 | 46,075,028,237 | 153,667,702,685 |
|  cat_Latn | 13,553,299,529 | 9,477,390 | 9,477,390 | 10,279,279,397 | 34,572,051,501 |
|  eus_Latn | 1,610,103,222 | 1,155,671 | 1,155,671 | 1,454,331,118 | 4,318,534,844 |
|  glg_Latn | 1,847,610,369 | 1,253,170 | 1,253,170 | 1,258,531,316 | 4,760,109,761 |
|  bos_Latn | 42,644,279 | 6,226 | 6,226 | 59,234,247 | 88,693,363 |
|  isl_Latn | 2,694,154,093 | 1,560,913 | 1,560,913 | 2,591,002,405 | 6,356,784,021 |
|  kat_Geor | 2,067,525,499 | 936,497 | 936,497 | 1,721,264,158 | 3,833,662,238 |
|  mkd_Cyrl | 2,128,866,081 | 1,358,293 | 1,358,293 | 1,602,877,239 | 4,451,886,420 |
|  als_Latn | 5,112,435,842 | 3,622,957 | 3,622,957 | 4,615,976,832 | 12,667,553,241 |
|  srp_Cyrl | 5,493,906,612 | 2,010,607 | 2,010,607 | 4,104,764,692 | 10,957,011,175 |
|  tur_Latn | 76,180,636,248 | 54,327,085 | 54,327,085 | 55,254,256,268 | 191,482,314,505 |
|  ukr_Cyrl | 48,452,415,634 | 24,968,305 | 24,968,305 | 31,677,007,258 | 95,173,965,329 |
|  nor_Latn | 29,338,666,326 | 14,864,710 | 14,864,710 | 22,418,792,894 | 74,784,171,188 |
| Total | 5,394,294,419,240 | 3,016,870,137 | 3,016,870,137 | 3,426,905,104,634 | 13,827,579,848,490 |



## <a id="access">Access Information</a>

The download site for the data is hosted at [HuggingFace](https://huggingface.co/datasets/allenai/MADLAD-400).

On select EuroHPC systems, the data is directly available for read-only access on the local filesytem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/madlad/1.0/clean/`
+ Leonardo: `/leonardo_work/openeurollm/training/madlad/1.0/clean/`


## <a id="use">Terms of Use</a>

The dataset is released with the [CC-BY-4.0]([https://creativecommons.org/licenses/by/4.0/deed.en](https://creativecommons.org/licenses/by/4.0/legalcode)) license, as stated in the [HuggingFace repository](https://huggingface.co/datasets/allenai/MADLAD-400) and the associated [GitHub repository](https://github.com/google-research/google-research/tree/master).
Any source files employed from the GitHub repository fall under the [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) license.

## <a id="curator">Catalogue Curators</a>

- Tudor Nicolae Mateiu, Prompsit Language Engineering, <tudornm@prompsit.com>
