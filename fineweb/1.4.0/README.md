# English FineWeb

**[DRAFT] (Version 1.4.0; July 2025)**

## <a id="background">Background</a>

FineWeb (version 1.4.0) is a collection of cleaned and deduplicated English web data from CommonCrawl.
The data selection pipeline is described in [Penedo et al., 2024](https://arxiv.org/abs/2406.17557) and more details can be found on its
[Hugging Face page](https://huggingface.co/datasets/HuggingFaceFW/fineweb)

FineWeb-Edu is a collection of data obtained by filtering the FineWeb dataset using an "educational content" classifier predictions.
The description of this dataset can be found on a separate [Hugging Face page](https://huggingface.co/datasets/HuggingFaceFW/fineweb-edu).

## <a id="sources">Data Sources</a>

The dataset is based on data from CommonCrawl, namely all the crawls between 2013 and 2025 (until June). It is organized in directories that match the original source crawls.
The extraction pipeline uses the datatrove library and can be reproduced by using the [provided scripts](https://github.com/huggingface/datatrove/blob/main/examples/fineweb.py).

## <a id="statistics">Structure & Statistics</a>

FineWeb is distributed as 27,465 Zstd-compressed JSONLines files, split into 110 directories that correspond to the source crawls.
Each directory contains files whose names follow the `xxx_yyyyy.jsonl.zst` naming patern, where `xxx` and `yyyyy` start at zero and denote the shard.

FineWeb-Edu follows the same directory structure but only contains 2,110 files, named either in the same `xxx_yyyyy.jsonl.zst` pattern as the FineWeb data files, or
in some crawls in the format of `train-xxxxx-of-NNNNN.jsonl.zst` where `xxxxx` starts at zero and goes up to `NNNNN`.

## <a id="languages">European Language Support</a>

There are two versions of the dataset, the original full release and the educational subset (see above).
For detailed statistics, see the [statistics for the full dataset](./data/counts.md) and [statistics for the educational subset](./edu/counts.md) in separate files.


## <a id="access">Access Information</a>

On select EuroHPC systems, the data is directly available for read-only access on the local filesytem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/fineweb1.4.0/data/`
+ Leonardo: `/leonardo_work/OELLM_Catalog/training/fineweb/1.4.0/data/`

+ LUMI: `/appl/local/openeurollm/training/catalogue/fineweb1.4.0/edu/`
+ Leonardo: `/leonardo_work/OELLM_Catalog/training/fineweb/1.4.0/edu/`

## <a id="use">Terms of Use</a>

The dataset is released under the Open Data Commons Attribution License (ODC-By) v1.0 [license](https://opendatacommons.org/licenses/by/1-0/).
The use of this dataset is also subject to CommonCrawl's [Terms of Use](https://commoncrawl.org/terms-of-use).

## <a id="citation">References</a>
```bibtex
@inproceedings{
  penedo2024the,
  title={The FineWeb Datasets: Decanting the Web for the Finest Text Data at Scale},
  author={Guilherme Penedo and Hynek Kydl{\'\i}{\v{c}}ek and Loubna Ben allal and Anton Lozhkov and Margaret Mitchell and Colin Raffel and Leandro Von Werra and Thomas Wolf},
  booktitle={The Thirty-eight Conference on Neural Information Processing Systems Datasets and Benchmarks Track},
  year={2024},
  url={https://openreview.net/forum?id=n6SCkn2QaG}
}

@misc{lozhkov2024fineweb-edu,
    author       = { Lozhkov, Anton and Ben Allal, Loubna and von Werra, Leandro and Wolf, Thomas },
    title        = { FineWeb-Edu: the Finest Collection of Educational Content },
    year         = 2024,
    url          = { https://huggingface.co/datasets/HuggingFaceFW/fineweb-edu },
    doi          = { 10.57967/hf/2497 },
    publisher    = { Hugging Face }
}
```

## <a id="curator">Catalogue Curator</a>

Jindřich Helcl, University of Oslo, <jindrich@ifi.uio.no>
