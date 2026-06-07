# MixtureVitae

**[DRAFT] (Version 1.0; May 2026)**

## <a id="background">Background</a>

MixtureVitae ([Nguyen et al., 2025](https://arxiv.org/abs/2509.25531)) is a 422B-token open
pretraining dataset designed to train competitive large language models using only
permissive-licensed and low-risk data sources, prioritizing legal safety and transparent
provenance. Additional details are available on the
[HuggingFace dataset page](https://huggingface.co/datasets/ontocord/MixtureVitae-v1-decontaminated).

## <a id="sources">Data Sources</a>

The dataset integrates three broad categories: (1) curated text from SEC filings, academic papers
(arXiv, PubMed), patents, MegaWika, and science/news/legal corpora including The Stack v1;
(2) synthetic instruction and reasoning data generated from permissive seeds (Magpie,
MetaMathQA, OpenMathInstruct, and others); and (3) web text from Nemotron-CC, MagaCorpus,
and FineFineWeb. Sources are classified into license tiers: Tier 1 (explicit open licenses and
public domain, ~352B tokens), Tier 2 (curated permissive repositories, ~52B tokens), and
Tier 3 (civic/government works, ~18B tokens).

## <a id="statistics">Structure & Statistics</a>

The dataset is distributed as 96 gzip-compressed JSONlines files, amounting to 463 GB on disk.
Files are organised into 13 partition directories named after the source type (e.g. `business/`,
`fineweb/`), each containing one or more files following the naming pattern
`PARTITION-N.jsonl.gz`.
| **Partition** | **Documents** | **Tokens** |
|---------------|--------------:|-----------:|
| business | 71,409 | 186,865,414 |
| fineweb | 17,737,210 | 14,436,503,592 |
| formatted_text | 12,415,053 | 12,605,307,997 |
| law | 11,620,104 | 19,292,986,569 |
| math | 3,625,213 | 12,494,968,949 |
| nemo_maga | 76,775,868 | 42,282,990,549 |
| news | 388,833 | 209,087,137 |
| science_tech | 17,060,133 | 48,370,901,222 |
| software | 53,574,346 | 64,701,512,820 |
| stackexchange | 29,235,912 | 24,249,423,192 |
| synthetic_instruct | 68,262,115 | 119,829,751,862 |
| wiki | 40,957,326 | 34,283,278,029 |
| youtube | 856,480 | 5,970,533,476 |
| **Total** | **332,580,002** | **398,914,110,808** |

## <a id="languages">European Language Support</a>

MixtureVitae is primarily English.

| **Code(s)** | **Bytes** | **Documents** | **Segments** | **Tokens** | **Characters** |
|-------------|----------:|--------------:|-------------:|-----------:|---------------:|
| **English** | 496,823,572,060 | 332,580,002 | 19,545,563,226 | 398,914,110,808 | 1,525,414,335,153 |

## <a id="access">Access Information</a>

The primary download site for the data is the [HuggingFace Hub](https://huggingface.co/datasets/ontocord/MixtureVitae-v1-decontaminated).

On select EuroHPC systems, the data is directly available for read-only access on the local filesystem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/mixturevitae/1.0/decontaminated/`

## <a id="use">Terms of Use</a>

The dataset is composed of permissive-licensed and public domain sources across three license
tiers. Consult the [dataset page](https://huggingface.co/datasets/ontocord/MixtureVitae-v1-decontaminated)
for the full source and license breakdown.

### Citation Information

```bibtex
@misc{nguyen2025mixturevitae,
  title={{MixtureVitae: Open Web-Scale Pretraining Dataset With High Quality Instruction and Reasoning Data Built from Permissive-First Text Sources}},
  author={Huu Nguyen and Victor May and Harsh Raj and Marianna Nezhurina and Yishan Wang and Yanqi Luo and Minh Chien Vu and Taishi Nakamura and Ken Tsui and Van Khue Nguyen and David Salinas and Aleksandra Krasnodebska and Christoph Schuhmann and Mats Leon Richter and Xuan-Son Vu and Jenia Jitsev},
  year={2025},
  eprint={2509.25531},
  archivePrefix={arXiv},
  primaryClass={cs.CL},
}
```

## <a id="curator">Catalogue Curator</a>

Jindřich Helcl, University of Oslo, <jindrich@uio.no>
