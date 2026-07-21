# Multilingual MADLAD-400

**[DRAFT] (Version 1.0; October 2021)**

## <a id="background">Background</a>

MADLAD-400 is a 3T token dataset based on Common Crawl containing 419 languages, designed to encompass a larger amount of languages than other datasets created using similar methods.
The data construction and preliminary experimental results of training are described in [Kudugunta et al. (2023)](https://arxiv.org/abs/2309.04662).
Additional details are available on the [Hugging Face dataset page](https://huggingface.co/datasets/allenai/MADLAD-400).

## <a id="sources">Data Sources</a>

The MADLAD-400 dataset is a document-level multilingual dataset derived from Common Crawl (CC).
The dataset is available in two deduplicated versions: a 5T token “noisy” dataset and a 3T token “clean” dataset.
The 5T dataset is obtained directly from CC, before applying document-level LangID and any specific filtering.
On the other hand, the 3T dataset is obtained by filtering with preliminary preprocessing steps, by training and applying a semi-supervised language identification model, by filtering out questionable content, and by applying three additional filters based on language and their “self-audit” quality review.

Additionally, each dataset is released in both a document-level form and a sentence-level form.

## <a id="statistics">Structure & Statistics</a>

Currently, the MADLAD-400 dataset is distributed in compressed `.jsonl.gz` format.

**Record Fields**

| **Field** | **Status** |
|-----------|------------|
| `text` | required |

## <a id="languages">European Language Support</a>

<details>
<summary><b>Dataset Statistics</b></summary>

| **Language** | **Documents** | **Segments** | **Tokens** | **Length** | **Characters** |
|-------------|--------------:|-------------:|-----------:|-----------:|---------------:|
| bul_Cyrl | 12,755,329 | 318,089,170 | 19,379,378,372 | 1,519.3 | 57,519,166,787 |
| bos_Latn | 1,362,582 | 16,561,738 | 1,039,843,154 | 763.1 | 3,315,995,186 |
| cat_Latn | 9,477,390 | 161,246,054 | 10,230,211,031 | 1,079.4 | 34,412,877,115 |
| ces_Latn | 38,254,671 | 782,003,964 | 50,641,752,764 | 1,323.8 | 147,129,608,269 |
| dan_Latn | 17,865,888 | 414,840,227 | 24,818,490,918 | 1,389.2 | 82,678,650,949 |
| deu_Latn | 225,111,495 | 4,714,056,170 | 250,586,605,713 | 1,113.2 | 1,004,842,296,612 |
| ell_Grek | 20,932,239 | 408,030,903 | 31,643,853,892 | 1,511.7 | 80,540,249,664 |
| eng_Latn | 1,528,918,474 | 33,536,056,592 | 1,672,075,472,183 | 1,093.6 | 7,409,152,930,360 |
| spa_Latn | 250,906,994 | 5,037,391,332 | 253,004,920,454 | 1,008.4 | 1,058,177,231,827 |
| est_Latn | 5,542,933 | 156,439,941 | 9,693,327,279 | 1,748.8 | 28,525,436,334 |
| eus_Latn | 1,155,671 | 21,503,490 | 1,449,131,360 | 1,253.9 | 4,297,442,456 |
| fin_Latn | 20,433,664 | 518,275,062 | 34,091,539,109 | 1,668.4 | 100,551,848,713 |
| fra_Latn | 216,945,532 | 5,294,071,409 | 266,896,618,604 | 1,230.2 | 1,030,071,771,965 |
| gle_Latn | 285,999 | 7,155,708 | 517,155,041 | 1,808.2 | 1,401,885,805 |
| glg_Latn | 1,253,170 | 22,214,683 | 1,253,474,247 | 1,000.2 | 4,738,722,152 |
| hrv_Latn | 2,841,400 | 48,765,415 | 3,052,556,822 | 1,074.3 | 9,551,377,899 |
| hun_Latn | 29,677,075 | 639,866,504 | 46,285,795,724 | 1,559.6 | 134,288,536,227 |
| isl_Latn | 1,560,913 | 33,625,298 | 2,538,148,475 | 1,626.1 | 6,295,780,714 |
| ita_Latn | 126,406,256 | 2,370,687,367 | 140,192,755,496 | 1,109.1 | 550,788,975,834 |
| kat_Geor | 936,497 | 21,007,964 | 1,715,164,093 | 1,831.5 | 3,813,243,356 |
| lit_Latn | 8,748,025 | 207,652,680 | 14,555,013,195 | 1,663.8 | 41,068,242,629 |
| lav_Latn | 5,007,982 | 128,111,732 | 9,178,026,207 | 1,832.7 | 23,783,005,442 |
| mkd_Cyrl | 1,358,293 | 22,537,454 | 1,595,073,936 | 1,174.3 | 4,430,377,748 |
| mlt_Latn | 265,388 | 6,442,877 | 537,698,463 | 2,026.1 | 1,337,526,863 |
| nld_Latn | 86,594,116 | 1,712,690,782 | 90,501,165,347 | 1,045.1 | 332,862,246,916 |
| nor_Latn | 14,864,710 | 362,238,227 | 22,319,567,967 | 1,501.5 | 74,430,412,709 |
| pol_Latn | 90,908,786 | 1,919,022,603 | 110,473,686,696 | 1,215.2 | 354,446,442,539 |
| por_Latn | 124,207,090 | 2,535,901,068 | 126,333,573,643 | 1,017.1 | 497,292,611,617 |
| ron_Latn | 35,397,563 | 719,816,716 | 44,464,924,868 | 1,256.2 | 147,450,421,593 |
| slk_Latn | 11,857,945 | 249,488,957 | 15,762,126,948 | 1,329.2 | 45,411,941,125 |
| slv_Latn | 6,310,419 | 167,944,159 | 10,213,569,732 | 1,618.5 | 30,375,878,660 |
| sqi_Latn | 3,622,957 | 62,093,245 | 4,597,164,105 | 1,268.9 | 12,605,592,596 |
| srp_Cyrl | 2,010,607 | 58,426,536 | 4,087,662,041 | 2,033.0 | 10,899,806,991 |
| swe_Latn | 35,153,050 | 823,634,886 | 45,804,479,925 | 1,303.0 | 152,850,413,236 |
| tur_Latn | 54,327,085 | 853,188,377 | 55,017,579,261 | 1,012.7 | 190,658,781,761 |
| ukr_Cyrl | 24,968,305 | 512,347,996 | 31,511,535,289 | 1,262.1 | 94,678,320,913 |
| **Total** | 3,018,226,493 | 64,863,427,286 | 3,408,059,042,354 | 1,129.2 | 13,766,676,051,562 |

</details>


## <a id="access">Access Information</a>

The primary download site for the data is the [Hugging Face Hub](https://huggingface.co/datasets/allenai/MADLAD-400).

On select EuroHPC systems, the data is directly available for read-only access on the local filesytem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/madlad/1.0/clean/`
+ Leonardo: `/leonardo_work/OELLM_Catalog/training/madlad/1.0/clean/`


## <a id="use">Terms of Use</a>

The dataset is released with the [CC-BY-4.0]([https://creativecommons.org/licenses/by/4.0/deed.en](https://creativecommons.org/licenses/by/4.0/legalcode)) license, as stated in the [Hugging Face repository](https://huggingface.co/datasets/allenai/MADLAD-400) and the associated [GitHub repository](https://github.com/google-research/google-research/tree/master).
Any source files employed from the GitHub repository fall under the [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) license.

## <a id="curator">Catalogue Curators</a>

- Tudor Nicolae Mateiu, Prompsit Language Engineering, <tudornm@prompsit.com>
