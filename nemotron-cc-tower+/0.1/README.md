# Multisynt Translations from Nemotron-CC

**[DRAFT] (Version 0.1; December 2025)**

## <a id="background">Background</a>

MT-Nemotron-CC is an open multilingual dataset comprising approximately one hundred billion tokens of English
source material from Nemotron-CC, machine-translated into multiple European languages. It was
produced by the MultiSynt team under the OpenEuroLLM project and is intended for multilingual
LLM pretraining. Additional details are available on the
[HuggingFace dataset page](https://huggingface.co/datasets/MultiSynt/MT-Nemotron-CC).

## <a id="sources">Data Sources</a>

Derived from the `high/actual` partition of
[Nemotron-CC](https://data.commoncrawl.org/contrib/Nemotron/Nemotron-CC/index.html)
([Su et al., 2024](https://arxiv.org/abs/2412.02595)), a high-quality Common Crawl-based
English dataset. Translations were produced using two neural machine translation model families:

- [Unbabel/Tower-Plus-9B](https://huggingface.co/Unbabel/Tower-Plus-9B): 16 European languages
- [Unbabel/Tower-Plus-72B](https://huggingface.co/Unbabel/Tower-Plus-72B): 5 European languages (subset of Tower-9B languages)

## <a id="statistics">Structure & Statistics</a>

The dataset is organized into two top-level partitions:

- `parallel/`: 140.4M documents aligned across all languages -- the same source documents
  translated into every target language -- plus the original English source under `eng_Latn/`.
- `additional/`: Per-language extra documents outside the parallel set, also including the
  English source under `eng_Latn/`.

Within each partition, translations are stored under `tower9b/<lang>/` or `tower72b/<lang>/`
subdirectories as zstd-compressed JSONlines files named `N.jsonl.zst`.

**Record Fields**

| **Field** | **Status** |
|-----------|------------|
| `partition` | required |
| `text` | required |
| `tokens` | required |
| `warc_record_id` | required |

## <a id="languages">European Language Support</a>

<details>
<summary><b>Per-partition statistics</b></summary>

| **Partition** | **Bytes** | **Documents** | **Segments** | **Tokens** | **Characters** |
|-------------|----------:|--------------:|-------------:|-----------:|---------------:|
| additional/eng_Latn | 26,863,988,759 | 14,430,137 | 735,847,522 | 17,922,231,939 | 82,020,609,454 |
| additional/tower72b/deu_Latn | 13,713,764,948 | 14,430,137 | 416,818,967 | 11,222,488,764 | 47,310,305,983 |
| additional/tower72b/fin_Latn | 10,971,428,935 | 13,530,558 | 357,525,533 | 12,217,655,017 | 38,200,622,081 |
| additional/tower72b/ita_Latn | 12,227,710,330 | 12,677,053 | 479,542,217 | 11,955,358,033 | 48,520,967,279 |
| additional/tower72b/spa_Latn | 14,196,486,568 | 14,429,723 | 520,743,239 | 12,829,573,460 | 55,124,102,005 |
| additional/tower72b/swe_Latn | 11,041,265,306 | 11,198,643 | 406,373,982 | 12,145,735,208 | 43,818,462,725 |
| additional/tower9b/dan_Latn | 9,824,684,581 | 11,679,922 | 270,884,397 | 8,504,681,545 | 29,233,514,350 |
| additional/tower9b/deu_Latn | 10,983,938,200 | 12,114,249 | 281,348,796 | 8,150,822,343 | 34,436,926,437 |
| additional/tower9b/fin_Latn | 9,172,638,906 | 10,842,327 | 241,017,683 | 8,833,295,408 | 27,043,497,607 |
| additional/tower9b/fra_Latn | 9,805,241,265 | 10,828,162 | 251,340,812 | 7,643,106,422 | 31,540,274,406 |
| additional/tower9b/hun_Latn | 10,346,642,374 | 12,067,061 | 262,347,656 | 10,009,220,775 | 30,337,435,651 |
| additional/tower9b/isl_Latn | 10,185,024,436 | 12,020,892 | 275,712,845 | 11,140,113,491 | 28,700,700,298 |
| additional/tower9b/ita_Latn | 10,279,080,359 | 11,846,597 | 273,661,864 | 7,861,346,143 | 32,494,813,251 |
| additional/tower9b/nld_Latn | 10,345,352,353 | 11,828,269 | 274,624,086 | 8,307,253,139 | 32,223,554,505 |
| additional/tower9b/nno_Latn | 9,370,441,839 | 11,254,476 | 263,769,414 | 8,327,122,652 | 27,476,888,615 |
| additional/tower9b/nob_Latn | 9,908,923,472 | 11,946,935 | 276,452,988 | 8,423,706,886 | 29,152,009,693 |
| additional/tower9b/pol_Latn | 10,649,787,585 | 12,158,279 | 277,032,336 | 9,115,020,843 | 31,173,159,243 |
| additional/tower9b/por_Latn | 10,322,545,181 | 11,970,113 | 281,406,976 | 7,641,213,632 | 31,880,119,667 |
| additional/tower9b/ron_Latn | 10,120,796,928 | 11,524,067 | 260,929,517 | 8,894,881,900 | 30,852,586,761 |
| additional/tower9b/spa_Latn | 10,050,759,030 | 11,583,567 | 270,923,060 | 7,239,148,269 | 32,082,035,956 |
| additional/tower9b/swe_Latn | 10,189,190,262 | 12,085,093 | 284,534,664 | 8,517,254,824 | 30,059,457,536 |
| additional/tower9b/ukr_Cyrl | 11,364,009,379 | 10,788,799 | 240,687,013 | 8,628,137,924 | 26,735,476,909 |
| parallel/eng_Latn | 115,712,243,173 | 140,359,346 | 3,314,788,973 | 72,804,271,100 | 337,066,594,510 |
| parallel/tower72b/deu_Latn | 120,111,394,936 | 140,359,346 | 3,155,683,159 | 89,011,699,616 | 375,832,672,909 |
| parallel/tower72b/fin_Latn | 111,487,813,349 | 140,359,346 | 3,103,914,474 | 109,155,167,633 | 334,044,437,060 |
| parallel/tower72b/ita_Latn | 115,543,698,677 | 140,359,346 | 3,309,245,271 | 90,358,300,064 | 372,275,184,538 |
| parallel/tower72b/spa_Latn | 115,590,336,567 | 140,359,346 | 3,272,658,708 | 84,953,917,955 | 373,978,955,797 |
| parallel/tower72b/swe_Latn | 112,687,058,337 | 140,359,346 | 3,271,826,382 | 96,848,885,433 | 341,912,094,918 |
| parallel/tower9b/dan_Latn | 113,106,087,746 | 140,359,346 | 3,106,784,278 | 97,586,517,917 | 335,182,394,513 |
| parallel/tower9b/deu_Latn | 122,255,997,350 | 140,359,346 | 3,127,195,040 | 90,545,101,333 | 382,230,814,160 |
| parallel/tower9b/fin_Latn | 115,507,906,396 | 140,359,346 | 3,056,627,000 | 111,203,941,484 | 340,509,801,387 |
| parallel/tower9b/fra_Latn | 121,446,405,124 | 140,359,346 | 3,101,346,725 | 94,511,511,303 | 389,254,684,230 |
| parallel/tower9b/hun_Latn | 116,275,568,191 | 140,359,346 | 2,950,010,090 | 112,284,126,218 | 340,140,820,175 |
| parallel/tower9b/isl_Latn | 115,147,555,238 | 140,359,346 | 3,110,354,571 | 125,671,935,015 | 323,695,009,298 |
| parallel/tower9b/ita_Latn | 116,960,724,113 | 140,359,346 | 3,104,719,513 | 89,317,743,245 | 368,921,212,191 |
| parallel/tower9b/nld_Latn | 117,581,857,336 | 140,359,346 | 3,104,082,446 | 94,149,312,178 | 365,041,807,758 |
| parallel/tower9b/nno_Latn | 112,018,306,047 | 140,359,346 | 3,131,063,961 | 99,238,002,150 | 327,375,559,622 |
| parallel/tower9b/nob_Latn | 112,257,250,282 | 140,359,346 | 3,122,923,300 | 95,203,311,189 | 329,322,024,187 |
| parallel/tower9b/pol_Latn | 118,366,454,509 | 140,359,346 | 3,074,024,182 | 101,112,135,462 | 345,635,686,743 |
| parallel/tower9b/por_Latn | 116,171,531,444 | 140,359,346 | 3,155,287,022 | 85,890,484,097 | 357,895,399,169 |
| parallel/tower9b/ron_Latn | 118,454,822,045 | 140,359,346 | 3,042,938,369 | 103,886,185,746 | 360,133,690,911 |
| parallel/tower9b/spa_Latn | 116,819,323,353 | 140,359,346 | 3,135,656,917 | 84,039,913,675 | 372,046,657,140 |
| parallel/tower9b/swe_Latn | 113,707,950,894 | 140,359,346 | 3,162,420,562 | 94,760,440,063 | 334,269,595,658 |
| parallel/tower9b/ukr_Cyrl | 141,762,783,261 | 140,359,346 | 2,985,246,916 | 107,338,345,113 | 332,256,212,631 |
| **Total** | **2,830,906,769,364** | **3,355,140,671** | **76,102,323,426** | **2,345,400,616,606** | **8,539,438,829,917** |

</details>

## <a id="access">Access Information</a>

The primary download site for the data is the [HuggingFace Hub](https://huggingface.co/datasets/MultiSynt/MT-Nemotron-CC).

On select EuroHPC systems, the data is directly available for read-only access on the local filesystem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/nemotron-cc-tower+/0.1/`
+ Leonardo: `/leonardo_work/openeurollm/training/nemotron-cc-tower+/0.1/`

## <a id="use">Terms of Use</a>

The dataset is released under the [Creative Commons CC0 license](https://creativecommons.org/publicdomain/zero/1.0/) (no rights reserved). Original web content remains subject to the rights of website owners and the [Common Crawl Terms of Use](https://commoncrawl.org/terms-of-use).

### Citation Information

```bibtex
@dataset{mt_nemotron_cc_2025,
  title={MT-Nemotron-CC: Large-Scale Machine-Translated High Quality Web Text},
  author={MultiSynt},
  year={2025},
  url={https://huggingface.co/datasets/MultiSynt/MT-Nemotron-CC}
}
```

## <a id="curator">Catalogue Curator</a>

Jindřich Helcl, University of Oslo, <jindrich@uio.no>
