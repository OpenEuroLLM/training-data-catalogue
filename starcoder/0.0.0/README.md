# StarCoder training data

**[DRAFT] (Version 0.0.0; June 2026)**

## <a id="background">Background</a>

This is the training dataset for the StarCoder and StarCoderBase code language models, developed by the BigCode community ([Li et al., 2023](https://arxiv.org/abs/2305.06161)). It covers 86 programming languages derived from The Stack v1, supplemented by GitHub Issues, Jupyter notebooks, and Git commits. The dataset underwent near-deduplication, PII removal, and benchmark decontamination before release.
Additional details are available on the [HuggingFace dataset page](https://huggingface.co/datasets/bigcode/starcoderdata).

## <a id="sources">Data Sources</a>

Derived from [The Stack v1](https://huggingface.co/datasets/bigcode/the-stack), a collection of GitHub repositories with permissive licenses. Supplementary content (GitHub Issues, Jupyter notebooks, Git commits) was collected from GitHub and similarly filtered and deduplicated.

## <a id="statistics">Structure & Statistics</a>

The dataset is organised into 86 programming language subsets and four special subsets:

- `github-issues-filtered-structured` -- filtered and structured GitHub issue threads
- `git-commits-cleaned` -- cleaned Git commit messages and diffs
- `jupyter-scripts-dedup-filtered` -- deduplicated Jupyter notebook scripts
- `jupyter-structured-clean-dedup` -- structured and cleaned Jupyter notebooks

Files are stored as Zstd-compressed JSONLines files within per-language and per-subset subdirectories.

**Note:** The primary text field in this dataset is `content`, not `text`.

<details>
<summary><b>Record Fields</b></summary>

| **Field** | **Status** |
|-----------|------------|
| `content` | required |
| `id` | required |
| `alphanum_fraction` | optional |
| `avg_line_length` | optional |
| `chain_length` | optional |
| `ext` | optional |
| `hexsha` | optional |
| `lang` | optional |
| `license` | optional |
| `max_stars_count` | optional |
| `max_stars_repo_licenses` | optional |
| `max_stars_repo_name` | optional |
| `max_stars_repo_path` | optional |
| `path` | optional |
| `repo_name` | optional |
| `size` | optional |

</details>

## <a id="languages">European Language Support</a>

StarCoder dataset contains code (natural language parts predominantly English). See below for statistic breakdown per programming language.

<details>
<summary><b>Dataset Statistics</b></summary>

| **Partition** | **Documents** | **Segments** | **Tokens** | **Length** | **Characters** |
|---------------|--------------:|-------------:|-----------:|-----------:|---------------:|
| ada | 30,934 | 7,211,727 | 75,625,434 | 2,444.7 | 261,856,209 |
| agda | 17,554 | 2,024,270 | 32,043,314 | 1,825.4 | 72,787,227 |
| alloy | 5,368 | 246,847 | 3,134,990 | 584.0 | 7,914,455 |
| antlr | 7,917 | 1,994,814 | 18,212,293 | 2,300.4 | 47,678,647 |
| applescript | 4,737 | 271,873 | 2,621,312 | 553.4 | 8,971,411 |
| assembly | 247,919 | 54,029,815 | 829,850,965 | 3,347.3 | 1,561,132,159 |
| augeas | 180 | 20,583 | 186,793 | 1,037.7 | 562,793 |
| awk | 10,289 | 851,217 | 8,363,193 | 812.8 | 21,541,170 |
| batchfile | 239,568 | 7,983,983 | 97,116,823 | 405.4 | 237,278,040 |
| bluespec | 5,928 | 915,326 | 11,030,037 | 1,860.7 | 32,228,409 |
| c | 8,536,791 | 1,681,029,311 | 21,156,472,894 | 2,478.3 | 53,993,170,236 |
| c-sharp | 10,801,285 | 1,222,275,256 | 11,449,115,550 | 1,060.0 | 44,877,316,643 |
| clojure | 125,163 | 12,608,332 | 142,821,205 | 1,141.1 | 461,734,681 |
| cmake | 186,375 | 10,617,594 | 157,041,688 | 842.6 | 457,613,615 |
| coffeescript | 226,209 | 20,492,348 | 196,780,900 | 869.9 | 644,461,099 |
| common-lisp | 98,733 | 35,235,979 | 536,285,671 | 5,431.7 | 1,397,971,824 |
| cpp | 6,353,527 | 1,487,813,602 | 17,023,816,102 | 2,679.4 | 49,011,910,653 |
| css | 2,721,616 | 572,034,593 | 5,069,113,078 | 1,862.5 | 11,969,442,232 |
| cuda | 58,151 | 15,610,287 | 199,749,900 | 3,435.0 | 559,675,378 |
| dart | 928,415 | 114,788,030 | 1,016,610,824 | 1,095.0 | 3,665,933,796 |
| dockerfile | 571,506 | 14,461,272 | 148,564,297 | 260.0 | 423,572,148 |
| elixir | 281,016 | 23,274,061 | 236,773,211 | 842.6 | 710,779,418 |
| elm | 62,033 | 10,496,760 | 80,431,788 | 1,296.6 | 298,908,032 |
| emacs-lisp | 52,838 | 11,026,639 | 132,988,446 | 2,516.9 | 410,509,486 |
| erlang | 98,447 | 19,979,810 | 235,806,265 | 2,395.3 | 703,997,740 |
| f-sharp | 124,066 | 15,730,214 | 175,675,832 | 1,416.0 | 614,182,673 |
| fortran | 158,792 | 50,583,039 | 702,223,284 | 4,422.3 | 1,779,194,091 |
| git-commits-cleaned | 7,634,718 | 1,637,483,747 | 16,926,480,820 | 2,217.0 | 56,828,076,051 |
| github-issues-filtered-structured | 30,982,955 | 936,703,826 | 19,266,595,302 | 621.8 | 60,211,150,417 |
| glsl | 167,701 | 13,576,338 | 178,931,639 | 1,067.0 | 408,039,557 |
| go | 4,700,526 | 823,999,415 | 8,602,502,965 | 1,830.1 | 23,816,881,133 |
| groovy | 250,834 | 25,962,392 | 244,436,539 | 974.5 | 911,003,882 |
| haskell | 541,454 | 64,300,198 | 675,804,049 | 1,248.1 | 2,232,554,652 |
| html | 3,299,965 | 667,168,048 | 9,256,983,511 | 2,805.2 | 29,347,213,270 |
| idris | 8,042 | 926,450 | 9,995,202 | 1,242.9 | 30,850,347 |
| isabelle | 5,001 | 1,907,361 | 31,281,932 | 6,255.1 | 83,508,911 |
| java | 20,071,773 | 2,527,605,799 | 24,208,822,783 | 1,206.1 | 87,407,794,777 |
| java-server-pages | 210,816 | 25,139,832 | 289,323,164 | 1,372.4 | 980,361,753 |
| javascript | 19,544,285 | 2,098,231,816 | 20,084,396,652 | 1,027.6 | 64,981,376,083 |
| json | 4,751,547 | 90,691,141 | 2,068,654,777 | 435.4 | 5,559,904,060 |
| julia | 295,364 | 39,871,523 | 490,356,655 | 1,660.2 | 1,317,887,998 |
| jupyter-scripts-dedup-filtered | 914,510 | 203,912,329 | 2,429,892,636 | 2,657.0 | 7,085,112,308 |
| jupyter-structured-clean-dedup | 668,743 | 98,040,910 | 2,028,794,971 | 3,033.7 | 5,897,389,773 |
| kotlin | 2,239,354 | 163,396,155 | 1,525,596,960 | 681.3 | 5,736,917,290 |
| lean | 16,870 | 2,648,222 | 37,131,124 | 2,201.0 | 94,764,899 |
| literate-agda | 523 | 151,604 | 1,881,632 | 3,597.8 | 4,814,600 |
| literate-coffeescript | 1,133 | 148,236 | 1,302,947 | 1,150.0 | 4,847,315 |
| literate-haskell | 6,104 | 1,580,577 | 16,523,654 | 2,707.0 | 53,166,253 |
| lua | 549,459 | 92,413,675 | 1,043,759,934 | 1,899.6 | 2,877,376,686 |
| makefile | 657,349 | 39,512,530 | 502,110,310 | 763.8 | 1,324,261,089 |
| maple | 1,152 | 119,836 | 1,623,005 | 1,408.9 | 3,867,387 |
| markdown | 21,029,287 | 1,660,865,737 | 23,669,000,678 | 1,125.5 | 74,805,371,432 |
| mathematica | 22,653 | 21,870,811 | 561,684,240 | 24,795.1 | 1,060,042,320 |
| matlab | 93 | 8,075 | 79,011 | 849.6 | 189,663 |
| ocaml | 158,356 | 29,570,115 | 353,993,583 | 2,235.4 | 1,030,489,819 |
| pascal | 110,981 | 47,083,795 | 737,459,492 | 6,644.9 | 1,676,295,946 |
| perl | 365,491 | 74,005,681 | 835,208,594 | 2,285.2 | 2,228,255,379 |
| php | 15,683,017 | 1,716,294,257 | 17,467,679,698 | 1,113.8 | 61,064,035,255 |
| powershell | 267,627 | 29,251,007 | 311,748,225 | 1,164.9 | 1,102,590,815 |
| prolog | 968 | 292,311 | 3,722,593 | 3,845.7 | 9,668,288 |
| protocol-buffer | 97,167 | 10,867,351 | 104,714,338 | 1,077.7 | 310,037,176 |
| python | 12,866,649 | 1,694,099,105 | 18,621,762,134 | 1,447.3 | 60,544,713,580 |
| r | 39,042 | 7,235,447 | 105,820,204 | 2,710.4 | 248,155,845 |
| racket | 3,688 | 699,873 | 7,698,163 | 2,087.4 | 26,198,640 |
| restructuredtext | 896,880 | 90,688,023 | 1,039,280,542 | 1,158.8 | 3,325,312,215 |
| rmarkdown | 5,386 | 1,446,850 | 18,633,689 | 3,459.7 | 57,664,823 |
| ruby | 3,390,320 | 219,326,499 | 2,149,079,494 | 633.9 | 6,859,828,935 |
| rust | 1,380,468 | 271,399,433 | 2,864,934,693 | 2,075.3 | 9,124,933,307 |
| sas | 9,226 | 6,843,715 | 53,373,179 | 5,785.1 | 115,316,107 |
| scala | 1,355,788 | 130,018,920 | 1,393,151,773 | 1,027.6 | 4,724,238,060 |
| scheme | 41,890 | 5,982,883 | 69,012,372 | 1,647.5 | 199,756,793 |
| shell | 2,206,327 | 101,308,469 | 1,101,969,345 | 499.5 | 3,125,373,332 |
| smalltalk | 587,748 | 19,356,182 | 200,502,695 | 341.1 | 583,633,281 |
| solidity | 153,194 | 30,175,693 | 296,379,719 | 1,934.7 | 853,747,547 |
| sparql | 13,716 | 942,506 | 16,282,186 | 1,187.1 | 37,171,322 |
| sql | 975,420 | 158,904,697 | 5,317,096,137 | 5,451.1 | 10,928,204,315 |
| stan | 5,429 | 395,191 | 5,569,349 | 1,025.9 | 13,179,858 |
| standard-ml | 19,630 | 5,083,327 | 70,004,758 | 3,566.2 | 191,362,241 |
| stata | 24,208 | 7,308,456 | 218,438,658 | 9,023.4 | 332,335,105 |
| systemverilog | 46,270 | 9,737,420 | 157,237,752 | 3,398.3 | 366,565,662 |
| tcl | 49,335 | 10,414,162 | 127,331,117 | 2,580.9 | 349,898,603 |
| tcsh | 4,806 | 481,894 | 6,760,686 | 1,406.7 | 16,177,686 |
| tex | 522,778 | 105,766,939 | 1,833,981,137 | 3,508.1 | 5,153,513,953 |
| thrift | 4,661 | 423,682 | 3,732,453 | 800.8 | 12,300,964 |
| typescript | 10,547,331 | 863,653,528 | 7,926,100,576 | 751.5 | 26,702,376,699 |
| verilog | 75 | 8,167 | 162,871 | 2,171.6 | 498,477 |
| vhdl | 58,208 | 20,566,046 | 398,699,314 | 6,849.6 | 862,839,975 |
| visual-basic | 161,239 | 35,259,834 | 406,721,154 | 2,522.5 | 1,419,733,247 |
| xslt | 42,103 | 11,010,464 | 147,060,552 | 3,492.9 | 482,987,439 |
| yacc | 7,451 | 3,946,741 | 38,037,543 | 5,105.0 | 110,457,557 |
| yaml | 3,995,948 | 134,892,182 | 1,274,096,190 | 318.8 | 3,786,958,814 |
| zig | 15,850 | 4,650,340 | 60,824,681 | 3,837.5 | 177,055,766 |
| **Total** | 206,642,239 | 22,491,235,350 | 259,636,664,820 | 1,256.5 | 815,450,910,997 |

</details>



## <a id="access">Access Information</a>

The primary download site for the data is the [HuggingFace Hub](https://huggingface.co/datasets/bigcode/starcoderdata).

On select EuroHPC systems, the data is directly available for read-only access on the local filesystem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/starcoder/0.0.0/data/`
+ Leonardo: `/leonardo_work/OELLM_Catalog/training/starcoder/0.0.0/data/`

## <a id="use">Terms of Use</a>

TODO

### Citation information

```bibtex
@misc{li2023starcodersourceyou,
      title={StarCoder: may the source be with you!}, 
      author={Raymond Li and Loubna Ben Allal and Yangtian Zi and Niklas Muennighoff and Denis Kocetkov and Chenghao Mou and Marc Marone and Christopher Akiki and Jia Li and Jenny Chim and Qian Liu and Evgenii Zheltonozhskii and Terry Yue Zhuo and Thomas Wang and Olivier Dehaene and Mishig Davaadorj and Joel Lamy-Poirier and João Monteiro and Oleh Shliazhko and Nicolas Gontier and Nicholas Meade and Armel Zebaze and Ming-Ho Yee and Logesh Kumar Umapathi and Jian Zhu and Benjamin Lipkin and Muhtasham Oblokulov and Zhiruo Wang and Rudra Murthy and Jason Stillerman and Siva Sankalp Patel and Dmitry Abulkhanov and Marco Zocca and Manan Dey and Zhihan Zhang and Nour Fahmy and Urvashi Bhattacharyya and Wenhao Yu and Swayam Singh and Sasha Luccioni and Paulo Villegas and Maxim Kunakov and Fedor Zhdanov and Manuel Romero and Tony Lee and Nadav Timor and Jennifer Ding and Claire Schlesinger and Hailey Schoelkopf and Jan Ebert and Tri Dao and Mayank Mishra and Alex Gu and Jennifer Robinson and Carolyn Jane Anderson and Brendan Dolan-Gavitt and Danish Contractor and Siva Reddy and Daniel Fried and Dzmitry Bahdanau and Yacine Jernite and Carlos Muñoz Ferrandis and Sean Hughes and Thomas Wolf and Arjun Guha and Leandro von Werra and Harm de Vries},
      year={2023},
      eprint={2305.06161},
      archivePrefix={arXiv},
      primaryClass={cs.CL},
      url={https://arxiv.org/abs/2305.06161}, 
}
```

## <a id="curator">Catalogue Curator</a>

Jindřich Helcl, University of Oslo, <jindrich@uio.no>
