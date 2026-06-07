# FinePhrase

**[DRAFT] (Version 0.0.0; May 2026)**

## <a id="background">Background</a>

FinePhrase ([Niklaus et al., 2026](https://arxiv.org/abs/2604.13977)) is a large-scale synthetic English pretraining dataset.
It is constructed by rephrasing documents from [FineWeb-Edu](https://huggingface.co/datasets/HuggingFaceFW/fineweb-edu) (sample-350BT) into four structured formats - FAQ, math problems, tables, and tutorials - using the SmolLM2-1.7B-Instruct model.
Details are available on the [HuggingFace dataset page](https://huggingface.co/datasets/HuggingFaceFW/finephrase).

## <a id="sources">Data Sources</a>

[FineWeb-Edu](https://huggingface.co/datasets/HuggingFaceFW/fineweb-edu) (sample-350BT), rephrased using [SmolLM2-1.7B-Instruct](https://huggingface.co/HuggingFaceTB/SmolLM2-1.7B-Instruct) via the [datatrove](https://github.com/huggingface/datatrove) library.

## <a id="statistics">Structure & Statistics</a>

The dataset is distributed as 27,104 Zstd-compressed JSONlines files, amounting to 2.6 TB on disk.
Files are organized into four partitions (`faq`, `math`, `table`, `tutorial`), each containing a single `train` split, following the naming pattern `NNN_NNNNN_N.jsonl.zst`.

| **Partition** | **Bytes** | **Documents** | **Segments** | **Tokens** | **Characters** |
|---------------|-----------:|--------------:|-------------:|-----------:|---------------:|
| faq | 733,629,434,706 | 338,973,447 | 7,075,490,244 | 344,777,251,977 | 1,601,991,334,135 |
| math | 664,216,543,679 | 338,747,732 | 7,070,860,869 | 344,550,428,346 | 1,600,927,196,681 |
| table | 654,614,460,054 | 338,546,433 | 7,067,018,478 | 344,351,703,087 | 1,599,992,461,837 |
| tutorial | 737,146,594,012 | 337,711,099 | 7,048,496,706 | 343,468,842,427 | 1,595,945,316,365 |
| **Total** | **2,789,607,032,451** | **1,353,978,711** | **28,261,866,297** | **1,377,148,225,837** | **6,398,856,309,018** |

## <a id="metadata">Available Metadata</a>

| **Field** | **Status** |
|-----------|------------|
| dataset | required |
| dump | required |
| file_path | required |
| id | required |
| int_score | required |
| language | required |
| language_score | required |
| rollout_results | required |
| score | required |
| text | required |
| token_count | required |
| url | required |

## <a id="languages">European Language Support</a>

FinePhrase is English-only.

| **Code(s)** | **Documents** | **Segments** | **Tokens** | **Characters** |
|-------------|--------------:|-------------:|-----------:|---------------:|
| **English** | 1,353,978,711 | 28,261,866,297 | 1,377,148,225,837 | 6,398,856,309,018 |

## <a id="access">Access Information</a>

The primary download site for the data is the [HuggingFace Hub](https://huggingface.co/datasets/HuggingFaceFW/finephrase).

On select EuroHPC systems, the data is directly available for read-only access on the local filesystem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/finephrase/0.0.0/data/`

## <a id="use">Terms of Use</a>

The dataset is released under the Open Data Commons Attribution License (ODC-By) v1.0 [license](https://opendatacommons.org/licenses/by/1-0/).

### Citation information

```bibtex
@misc{niklaus2026_the_synthetic_data_playbook_generating_trillions_of_the_finest_tokens,
  title={The Synthetic Data Playbook: Generating Trillions of the Finest Tokens},
  author={Joel Niklaus and Guilherme Penedo and Hynek Kydlicek and Elie Bakouch and Lewis Tunstall and Ed Beeching and Thibaud Frere and Colin Raffel and Leandro von Werra and Thomas Wolf},
  year={2026},
}
```

## <a id="curator">Catalogue Curator</a>

Jindřich Helcl, University of Oslo, <jindrich@uio.no>
