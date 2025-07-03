# HPLT Monolingual Datasets Version 2.0

## Background

The HPLT Monolingual Datasets 2.0 were released in September 2024.

## Data Sources

This dataset is comprised of text derived from web crawls, predominantly so-called wide crawls conducted by the Internet Archive (IA) between 20XX and 20YY, complemented with a smaller portion of Common Crawl (CC) data from between 20XX and 20YY.
HTML documents and metadata were extracted using the [warc2text tool](https://github.com/bitextor/warc2text), and subsequently ‘main content’ text was extracted using the Trafilatura](https://github.com/adbar/trafilatura) library.
Language identification for a total of 193 distinct language codes was performed with [OpenLID](https://github.com/laurieburchell/open-lid-dataset).

The dataset is internally organized into so-called collections, corresponding to either one complete released in two variants, called _deduplicated_ and _cleaned_, where the first

## Key Statistics


## Language Support

| **Code(s)** | **Bytes** | **Documents** | **Segments** | **Characters** |
|--------------|-----------|---------------|--------------|----------------|
|  bul_Cyrl | 44,283,861,975 | 28,087,181 | 681,406,236 | 96,934,273,361 |
|  ces_Latn | 109,711,940,916 | 75,288,021 | 1,926,503,033 | 273,936,688,894 |
|  dan_Latn | 46,874,204,383 | 33,841,408 | 873,022,625 | 133,380,682,616 |
|  deu_Latn | 643,563,226,429 | 482,053,407 | 11,127,774,286 | 1,782,129,825,333 |
|  ell_Grek | 125,752,059,355 | 70,328,890 | 1,849,481,662 | 283,534,611,644 |
|  eng_Latn | 6,199,414,043,792 | 4,388,525,961 | 116,521,950,325 | 17,083,161,859,947 |
|  est_Latn | 13,143,473,236 | 8,449,320 | 264,422,814 | 36,018,221,232 |
|  fin_Latn | 55,164,578,152 | 34,815,601 | 976,622,086 | 155,678,802,052 |
|  fra_Latn | 528,153,012,485 | 401,831,660 | 10,557,148,321 | 1,457,428,851,611 |
|  gle_Latn | 608,544,067 | 490,787 | 10,993,158 | 1,749,350,336 |
|  hrv_Latn | 18,455,135,510 | 12,303,820 | 297,132,744 | 47,995,473,960 |
|  hun_Latn | 84,104,083,079 | 51,870,492 | 1,418,772,876 | 225,200,264,565 |
|  ita_Latn | 298,427,404,410 | 221,752,424 | 5,127,292,899 | 820,602,938,696 |
|  ltg_Latn | 8,823,903 | 9,209 | 151,382 | 26,877,428 |
|  ltg_Latn lvs_Latn | 9,240,310,207 | 6,780,843 | 173,958,974 | 25,209,419,142 |
|  lit_Latn | 18,792,388,046 | 13,338,275 | 322,156,374 | 50,393,738,585 |
|  mlt_Latn | 473,820,795 | 367,265 | 8,675,475 | 1,441,648,250 |
|  nld_Latn | 163,348,254,430 | 138,651,084 | 3,074,592,386 | 451,077,252,328 |
|  pol_Latn | 235,852,448,102 | 175,410,669 | 4,460,832,917 | 631,594,269,186 |
|  por_Latn | 322,955,910,917 | 237,812,825 | 6,124,611,786 | 896,547,444,407 |
|  ron_Latn | 92,755,690,867 | 65,876,383 | 1,696,970,479 | 250,658,132,448 |
|  slk_Latn | 28,347,675,196 | 21,827,259 | 494,278,579 | 70,372,196,449 |
|  slv_Latn | 13,480,602,614 | 10,277,173 | 238,644,943 | 35,258,183,993 |
|  spa_Latn | 696,098,726,982 | 503,073,098 | 12,121,752,157 | 1,953,862,248,952 |
|  swe_Latn | 93,095,597,524 | 66,812,562 | 1,754,677,064 | 251,109,959,822 |
|  cat_Latn | 22,164,638,576 | 18,553,883 | 383,335,831 | 60,186,591,495 |
|  eus_Latn | 2,187,606,572 | 1,974,218 | 37,621,611 | 6,052,165,410 |
|  glg_Latn | 3,677,366,325 | 3,020,164 | 61,177,888 | 10,108,660,186 |
|  bos_Latn | 18,404,991,480 | 14,613,088 | 268,156,648 | 46,070,953,520 |
|  isl_Latn | 3,658,429,281 | 2,840,735 | 69,643,257 | 9,593,246,968 |
|  kat_Geor | 5,248,761,917 | 3,335,164 | 63,722,098 | 10,155,612,392 |
|  mkd_Cyrl | 4,353,674,682 | 3,565,647 | 57,008,331 | 9,439,624,767 |
|  als_Latn | 6,144,592,594 | 5,385,262 | 95,101,980 | 16,095,653,237 |
|  srp_Cyrl | 7,691,997,099 | 4,123,458 | 93,809,457 | 16,156,879,041 |
|  tur_Latn | 105,086,134,521 | 84,541,414 | 1,941,885,324 | 283,639,575,889 |
|  ukr_Cyrl | 83,197,910,551 | 47,395,787 | 1,169,038,372 | 182,867,693,190 |
|  nno_Latn | 1,870,209,895 | 1,423,143 | 34,603,409 | 5,404,227,611 |
|  nno_Latn nob_Latn | 51,074,925,109 | 28,476,988 | 710,577,489 | 138,648,073,341 |

## Access Information

## Terms of Use

## Catalogue Curator

Stephan Oepen, University of Oslo, <oe@ifi.uio.no>
