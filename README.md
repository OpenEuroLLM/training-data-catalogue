# OpenEuroLLM Catalogue of LLM Training Data

## Background

There is a bit of a growth industry in (pre-)training data preparation for LLM development.
This page aims to offer navigational help in the dataset landscape, essentially providing a structured ‘catalogue’ of available resources.
Originally, the catalogue is constructed for internal use in the [OpenEuroLLM](https://openeurollm.eu/) initiative, i.e. will put most emphasis on datasets used in the project.
At the same time, we hope that this overview may become useful to others and can grow into a community-supported resource.
The catalogue is accompanied by a curated collection of (a subset of) LLM (pre-)training datasets that are publicly made available (read-only) on multiple EuroHPC systems, currently:

+ LUMI: `/appl/local/openeurollm/training/catalogue/`

To nominate additional resources for inclusion in the catalogue or discuss specifics of emerging entries, please create a [GitHub issue on this repository](https://github.com/OpenEuroLLM/training-data-catalogue/issues).


## (Mostly) English Pre-Training Data

+ C4 ([Raffel, et al., 2019](https://arxiv.org/abs/1910.10683))
+ The Pile
+ RefinedWeb
+ RedPajama
+ Dolma
+ **[FineWeb 1](fineweb/1.3.0/README.md)** ([Penedo, et al., 2024](https://arxiv.org/abs/2406.17557))
+ **DCLM** ([Li, et al., 2024](https://arxiv.org/pdf/2406.11794))
+ **NEMOTRON-CC** ([Su, et al., 2024](https://arxiv.org/abs/2412.02595))
+ **[Common Pile](common-pile/0.1/README.md)** ([Kandpal, et al., 2025](https://arxiv.org/abs/2506.05209))

## Multilingual Pre-Training Data

+ mC4
+ CulturaX
+ **[HPLT](hplt/README.md)** ([De Gilbert, et al., 2024](https://arxiv.org/abs/2403.14009), [Burchell, et al. (2025)](https://arxiv.org/abs/2503.10267))
+ **FineWeb 2** (https://github.com/huggingface/fineweb-2)
+ MADLAD-400 ([Kudugunta, et al., 2023](https://arxiv.org/abs/2309.04662))
+ TxT360 (https://huggingface.co/spaces/LLM360/TxT360)

## Parallel Pre-Training Data


## Non-Language Pre-Training Data

+ **StarCoder**
+ The Stack
+ Proof-Pile-2 ([HuggingFace](https://huggingface.co/datasets/EleutherAI/proof-pile-2)) ([Azerbayev et al., 2023](https://arxiv.org/abs/2310.10631)), comprised by the following subsets:
   + arxiv from RedPajama
   + OpenWebMath ([Paster et al., 2023](https://arxiv.org/abs/2310.06786))
   + AlgebraicStack ([Azerbayev et al., 2023](https://arxiv.org/abs/2310.10631))
