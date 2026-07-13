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
`CATEGORY-N.jsonl.gz`, where each partition can contain multiple `CATEGORY` file patterns.

**Record Fields**
| **Field** | **Status** |
|-----------|------------|
| `id` | required |
| `metadata` | required |
| `text` | required |


## <a id="languages">European Language Support</a>

MixtureVitae is primarily English.

| **Partition** | **Bytes** | **Documents** | **Segments** | **Tokens** | **Length** | **Characters** |
|---------------|----------:|--------------:|-------------:|-----------:|-----------:|---------------:|
| business | 268,799,324 | 71,409 | 3,923,621 | 186,865,414 | 2,616.8 | 911,157,603 |
| fineweb | 25,324,667,733 | 17,737,210 | 345,827,103 | 14,436,503,592 | 813.9 | 65,754,289,394 |
| formatted_text | 15,605,111,739 | 12,415,053 | 979,442,980 | 12,605,307,997 | 1,015.3 | 44,460,477,077 |
| law | 28,820,738,853 | 11,620,104 | 290,460,016 | 19,292,986,569 | 1,660.3 | 85,146,461,755 |
| math | 7,922,845,263 | 3,625,213 | 674,824,563 | 12,494,968,949 | 3,446.7 | 29,300,978,002 |
| nemo_maga | 58,015,025,747 | 76,775,868 | 2,322,752,618 | 42,282,990,549 | 550.7 | 175,123,117,592 |
| news | 412,096,955 | 388,833 | 907,431 | 209,087,137 | 537.7 | 1,016,090,548 |
| science_tech | 62,730,325,241 | 17,060,133 | 572,540,366 | 48,370,901,222 | 2,835.3 | 204,616,839,346 |
| software | 61,884,038,396 | 53,574,346 | 5,777,050,867 | 64,701,512,820 | 1,207.7 | 213,924,158,145 |
| stackexchange | 34,208,409,753 | 29,235,912 | 1,471,185,352 | 24,249,423,192 | 829.4 | 88,917,320,548 |
| synthetic_instruct | 137,671,003,154 | 68,262,115 | 5,760,925,283 | 119,829,751,862 | 1,755.4 | 484,141,022,867 |
| wiki | 55,013,171,027 | 40,957,326 | 1,326,385,712 | 34,283,278,029 | 837.0 | 106,505,305,051 |
| youtube | 8,947,338,875 | 856,480 | 19,337,314 | 5,970,533,476 | 6,971.0 | 25,597,117,225 |
| **Total** | 496,823,572,060 | 332,580,002 | 19,545,563,226 | 398,914,110,808 | 1,199.5 | 1,525,414,335,153 |


## <a id="access">Access Information</a>

The primary download site for the data is the [HuggingFace Hub](https://huggingface.co/datasets/ontocord/MixtureVitae-v1-decontaminated).

On select EuroHPC systems, the data is directly available for read-only access on the local filesystem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/mixturevitae/1.0/decontaminated/`
+ Leonardo: `/leonardo_work/OELLM_Catalog/training/mixturevitae/1.0/decontaminated/`

## <a id="use">Terms of Use</a>

The dataset is composed of permissive-licensed and public domain sources across three license
tiers. Consult the [dataset page](https://huggingface.co/datasets/ontocord/MixtureVitae-v1-decontaminated)
for the full source and license breakdown.

### Citation Information

```bibtex
@misc{nguyen2025mixturevitaeopenwebscalepretraining,
      title={MixtureVitae: Open Web-Scale Pretraining Dataset With High Quality Instruction and Reasoning Data Built from Permissive-First Text Sources},
      author={Huu Nguyen and Victor May and Harsh Raj and Marianna Nezhurina and Yishan Wang and Yanqi Luo and Minh Chien Vu and Taishi Nakamura and Ken Tsui and Van Khue Nguyen and David Salinas and Aleksandra Krasnodębska and Christoph Schuhmann and Mats Leon Richter and Xuan-Son and Vu and Jenia Jitsev},
      year={2025},
      eprint={2509.25531},
      archivePrefix={arXiv},
      primaryClass={cs.CL},
      url={https://arxiv.org/abs/2509.25531},
}
```

## <a id="curator">Catalogue Curator</a>

Jindřich Helcl, University of Oslo, <jindrich@uio.no>
