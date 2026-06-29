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

<details>
<summary><b>Record fields</b></summary>

| **Field** | **Status** |
|-----------|------------|
| `dataset` | required |
| `dump` | required |
| `file_path` | required |
| `id` | required |
| `int_score` | required |
| `language` | required |
| `language_score` | required |
| `rollout_results` | required |
| `score` | required |
| `text` | required |
| `token_count` | required |
| `url` | required |

</details>

## <a id="languages">European Language Support</a>

FinePhrase is English-only.

| **Partition** | **Documents** | **Segments** | **Tokens** | **Length** | **Characters** |
|---------------|--------------:|-------------:|-----------:|-----------:|---------------:|
| faq | 338,973,447 | 7,540,762,484 | 144,264,553,129 | 425.6  |687,663,875,186 |
| math | 338,747,732 | 4,707,804,998 | 95,712,666,211 | 282.5 | 404,479,904,121 |
| table | 338,546,433 | 5,056,398,354 | 90,623,736,636 | 267.7 | 432,001,135,297 |
| tutorial | 337,711,099 | 8,551,132,621 | 142,641,519,968 | 422.4 | 669,454,139,311 |
| **Total** | 1,353,978,711 | 25,856,098,457 | 473,242,475,944 | 349.5 | 2,193,599,053,915 |

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
