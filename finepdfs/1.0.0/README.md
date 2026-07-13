# Multilingual FinePDFs

**[DRAFT] (Version 1.0.0; September 2025)**

## <a id="background">Background</a>

FinePDFs is a collection of PDF documents extracted from CommonCrawl for
language model pre-training. The dataset construction methodology is described
in research papers linked on its
[Hugging Face page](https://huggingface.co/datasets/HuggingFaceFW/finepdfs).

FinePDFs-edu is a subset of the data obtained by filtering the FinePDFs
dataset using an "educational content" classifier based on FineWeb-Edu
quality predictions. The description of this dataset can be found on a
separate
[Hugging Face page](https://huggingface.co/datasets/HuggingFaceFW/finepdfs-edu).

This catalogue entry provides both the full relerase of FinePDFs, in the `data/` subdirectory,
as well as the educational subset, in the `edu/` subdirectory.

## <a id="sources">Data Sources</a>

The dataset is based on data from CommonCrawl, sourced from 105 snapshots
spanning from 2013 to 2025. Documents are organized by
language code directories, with each
language further subdivided into train and test splits.

The extraction pipeline uses the datatrove library and can be reproduced
by using the [provided scripts](https://github.com/huggingface/datatrove/blob/main/examples/fineweb.py).

## <a id="statistics">Structure & Statistics</a>

The dataset is distributed as 4,240 Zstd-compressed JSONlines files,
amounting to a total of 3.8 TB on disk.
The dataset is organized into two main collections: `edu` (729 GB, 1,147 files)
containing educational content, and `data` (3.1 TB, 3,093 files) containing general content.
Files are organized by language code directories, with each language directory
containing `train` and `test` subdirectories.
Each subdirectory contains files whose names follow the `xxx_yyyyy.jsonl.zst` naming pattern,
where `xxx` and `yyyyy` start at zero and denote the shard.

## <a id="metadata">Available Metadata</a>

| **Field** | **Status** |
|-----------|------------|
| text | required |
| id | required |
| dump | required |
| url | required |
| date | required |
| file_path | required |
| offset | required |
| token_count | required |
| language | required |
| page_average_lid | required |
| page_average_lid_score | required |
| full_doc_lid | required |
| full_doc_lid_score | required |
| per_page_languages | required |
| is_truncated | required |
| extractor | required |
| page_ends | required |
| fw_edu_scores | required |
| minhash_cluster_size | required |
| duplicate_count | required |

## <a id="languages">European Language Support</a>

The dataset is internally partitioned by languages, and each language
is further subdivided into a `train` and `test` portion.
OpenEuroLLM statistics for the `train` portions are available for both
the [full](data/counts.md) and [educational](edu/counts.md) versions.


## <a id="access">Access Information</a>

On select EuroHPC systems, the data is directly available for read-only access on the local filesytem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/finepdfs/1.0.0/data/`
+ Leonardo: `/leonardo_work/OELLM_Catalog/training/finepdfs/1.0.0/data/`

## <a id="use">Terms of Use</a>

The dataset is released under the Open Data Commons Attribution License (ODC-By) v1.0 [license](https://opendatacommons.org/licenses/by/1-0/).
The use of this dataset is also subject to CommonCrawl's [Terms of Use](https://commoncrawl.org/terms-of-use)

### Citation Information
```bibtex
@misc{kydlicek2025finepdfs,
      title={FinePDFs},
      author={Hynek Kydl{\'\i}{\v{c}}ek and Guilherme Penedo and Leandro von Werra},
      year={2025},
      publisher = {Hugging Face},
      journal = {Hugging Face repository},
      howpublished = {\url{https://huggingface.co/datasets/HuggingFaceFW/finepdfs}}
}
```

## <a id="curator">Catalogue Curator</a>

Jindřich Helcl, University of Oslo, <jindrich@uio.no>
