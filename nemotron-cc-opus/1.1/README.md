# Multisynt OPUS-MT Translations from Nemotron-CC

**[DRAFT] (Version 1.1; July 2026)**

## <a id="background">Background</a>

MultiSynt/MT is a trillion-token, multi-parallel machine-translated dataset
produced by translating the English documents of the
[Nemotron-CC](https://huggingface.co/datasets/nvidia/Nemotron-CC) corpus into
36 languages by two different translation systems ([Idahl et al.,
2026](https://arxiv.org/abs/2607.00890)). This part of the MultiSynt effort was
carried out with the [OPUS-MT](https://github.com/Helsinki-NLP/OPUS-MT)
collection of Marian-NMT models ([Tiedemann et al.,
2023](https://doi.org/10.1007/s10579-023-09704-w)).  Version 1.1 adds
translations for nine additional higher-resource languages on top of the
original 27-language release.  Additional details are available on the
[HuggingFace dataset
page](https://huggingface.co/datasets/Helsinki-NLP/nemotron-cc-translated).

## <a id="sources">Data Sources</a>

Source text is the high-quality partition of [Nemotron-CC](https://huggingface.co/datasets/nvidia/Nemotron-CC),
a large-scale pretraining corpus derived from Common Crawl. Each English document was
translated independently into every target language using the dedicated OPUS-MT (and, for some language
pairs, HPLT-MT) model for that language pair, run with Marian-NMT.

## <a id="statistics">Structure & Statistics</a>

The dataset is distributed as 8,100 gzipped JSONlines files, organised into one directory per target
language, named by its ISO 639-3 (plus ISO 15924 script where relevant, e.g. `srp_Cyrl`) code. Languages
added in the original release share the lower-resource document pool (~156M documents translated from the
same Nemotron-CC subset); the nine languages added in version 1.1 use the larger, higher-resource pool
(~316M documents). Because every language subset is a translation of the same underlying English documents,
document and segment counts are identical within a resource tier, while token, character, and length
statistics vary by target language.

**Record Fields**

| **Field** | **Status** |
|-----------|------------|
| `language` | required |
| `text` | required |
| `url` | required |
| `warc_record_id` | required |

## <a id="languages">European Language Support</a>

The dataset covers 36 European languages. See below for the per-language statistic breakdown.

<details>
<summary><b>Dataset Statistics</b></summary>

| **Code(s)** | **Documents** | **Segments** | **Tokens** | **Length** | **Characters** |
|-------------|--------------:|-------------:|-----------:|-----------:|---------------:|
| bos | 156,431,999 | 3,851,874,477 | 113,835,888,390 | 727.7 | 371,189,680,444 |
| bul | 316,020,674 | 9,179,823,326 | 329,071,669,827 | 1,041.3 | 1,038,915,731,185 |
| cat | 156,431,999 | 3,851,874,477 | 131,331,952,634 | 839.5 | 458,581,558,375 |
| ces | 316,020,674 | 9,179,823,326 | 300,570,892,432 | 951.1 | 933,665,218,445 |
| dan | 156,431,999 | 3,851,874,477 | 122,036,887,786 | 780.1 | 422,941,474,309 |
| deu | 156,431,999 | 3,851,874,477 | 112,102,166,600 | 716.6 | 474,550,233,717 |
| ell | 156,431,999 | 3,851,874,477 | 174,215,344,981 | 1,113.7 | 476,232,786,477 |
| est | 316,020,674 | 9,179,823,326 | 309,504,604,061 | 979.4 | 939,767,760,171 |
| eus | 156,431,999 | 3,851,874,477 | 127,924,709,914 | 817.8 | 388,886,373,844 |
| fin | 316,020,674 | 9,179,823,326 | 329,241,138,953 | 1,041.8 | 1,014,408,990,786 |
| fra | 156,431,999 | 3,851,874,477 | 115,047,209,989 | 735.4 | 481,266,777,866 |
| gle | 316,020,674 | 9,179,823,326 | 392,131,195,222 | 1,240.8 | 1,075,369,251,819 |
| glg | 156,431,999 | 3,851,874,477 | 112,025,651,343 | 716.1 | 442,106,403,925 |
| hrv | 156,431,999 | 3,851,874,477 | 125,489,499,475 | 802.2 | 411,247,551,557 |
| hun | 156,431,999 | 3,851,874,477 | 141,049,113,491 | 901.7 | 431,092,997,602 |
| isl | 156,431,999 | 3,851,874,477 | 152,076,289,708 | 972.2 | 396,545,745,986 |
| ita | 156,431,999 | 3,851,874,477 | 111,900,831,249 | 715.3 | 463,071,338,486 |
| kat | 156,431,999 | 3,851,874,477 | 171,951,256,331 | 1,099.2 | 418,688,833,298 |
| lav | 156,431,999 | 3,851,874,477 | 154,209,765,986 | 985.8 | 412,170,277,675 |
| lit | 156,431,999 | 3,851,874,477 | 145,101,320,463 | 927.6 | 420,069,992,353 |
| mkd | 156,431,999 | 3,851,874,477 | 154,635,536,702 | 988.5 | 441,003,337,167 |
| mlt | 156,431,999 | 3,851,874,477 | 178,403,590,517 | 1,140.5 | 446,284,453,336 |
| nld | 156,431,999 | 3,851,874,477 | 118,143,789,319 | 755.2 | 459,591,093,078 |
| nno | 156,431,999 | 3,851,874,477 | 124,786,583,338 | 797.7 | 412,096,959,098 |
| nob | 156,431,999 | 3,851,874,477 | 119,704,107,080 | 765.2 | 416,820,411,487 |
| pol | 156,431,999 | 3,851,874,477 | 126,784,875,752 | 810.5 | 433,701,090,842 |
| por | 156,431,999 | 3,851,874,477 | 107,460,517,850 | 686.9 | 451,256,567,273 |
| ron | 316,020,674 | 9,179,823,326 | 307,214,090,552 | 972.1 | 1,070,427,785,588 |
| slk | 156,431,999 | 3,851,874,477 | 135,934,635,423 | 869.0 | 408,193,280,069 |
| slv | 156,431,999 | 3,851,874,477 | 132,951,991,962 | 849.9 | 408,899,904,480 |
| spa | 156,431,999 | 3,851,874,477 | 104,337,889,890 | 667.0 | 464,407,561,796 |
| sqi | 156,431,999 | 3,851,874,477 | 161,786,539,042 | 1,034.2 | 451,338,417,599 |
| srp_Cyrl | 156,431,999 | 3,851,874,477 | 148,081,074,910 | 946.6 | 406,318,813,545 |
| swe | 316,020,674 | 9,179,823,326 | 279,293,664,148 | 883.8 | 988,581,832,165 |
| tur | 316,020,674 | 9,179,823,326 | 272,173,433,018 | 861.3 | 986,832,984,920 |
| ukr | 316,020,674 | 9,179,823,326 | 318,573,954,277 | 1,008.1 | 999,223,889,282 |
| **Total** | 7,067,850,039 | 186,619,020,813 | 6,461,083,662,615 | 914.2 | 20,715,747,360,045 |

</details>

## <a id="access">Access Information</a>

The primary download site for the data is the [HuggingFace Hub](https://huggingface.co/datasets/Helsinki-NLP/nemotron-cc-translated).

On select EuroHPC systems, the data is directly available for read-only access on the local filesystem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/nemotron-cc-opus/1.1/`
+ Leonardo: `/leonardo_work/OELLM_Catalog/training/nemotron-cc-opus/1.1/`


## <a id="use">Terms of Use</a>

The dataset is released under the [Creative Commons CC0 license](https://creativecommons.org/publicdomain/zero/1.0/) (no rights reserved). Original web content remains subject to the rights of website owners and the [Common Crawl Terms of Use](https://commoncrawl.org/terms-of-use).

### Citation Information

The translation effort has been described in the following paper:

```bibtex
@misc{idahl2026multisyntmttrilliontokenmultiparallelpretraining,
      title={MultiSynt/MT: Trillion-Token Multi-Parallel Pre-Training Data Translated Across 36 Languages},
      author={Maximilian Idahl and Jörg Tiedemann and Sampo Pyysalo and David Salinas and Tomasz Galica and Shenbin Qian and Tudor Nicolae Mateiu and Zihao Li and Anna Lokrantz and Fedor Vitiugin and André F. T. Martins and Jenna Kanerva and Filip Ginter and Matthias Lindemann and Tim Isbister and Birger Moell and Jonas Lindh and Jan Hajič and Jenia Jitsev and Andrey Kutuzov and Stephan Oepen and Gema Ramírez-Sánchez},
      year={2026},
      eprint={2607.00890},
      archivePrefix={arXiv},
      primaryClass={cs.CL},
      url={https://arxiv.org/abs/2607.00890},
}
```

The OPUS-MT collection of models used to create the translations is published here:

```bibtex
@article{tiedemann2023democratizing,
  title={Democratizing neural machine translation with {OPUS-MT}},
  author={Tiedemann, J{\"o}rg and Aulamo, Mikko and Bakshandaeva, Daria and Boggia, Michele and Gr{\"o}nroos, Stig-Arne and Nieminen, Tommi and Raganato, Alessandro and Scherrer, Yves and Vazquez, Raul and Virpioja, Sami},
  journal={Language Resources and Evaluation},
  number={58},
  pages={713--755},
  year={2023},
  publisher={Springer Nature},
  issn={1574-0218},
  doi={10.1007/s10579-023-09704-w}
}
```

## <a id="curator">Catalogue Curator</a>

Jindřich Helcl, University of Oslo, <jindrich@uio.no>
