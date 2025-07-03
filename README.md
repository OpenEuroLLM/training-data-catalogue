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

+ C4 ([Raffel, et al., 2019](https://arxiv.org/abs/1910.10683), [HF repo](https://huggingface.co/datasets/allenai/c4))
+ The Pile
+ RefinedWeb
+ RedPajama v1
+ RedPajama v2
+ SlimPajama
+ Dolma
+ **[FineWeb 1](fineweb/1.3.0/README.md)** ([Penedo, et al., 2024](https://arxiv.org/abs/2406.17557))
+ **DCLM-baseline 1.0** ([Li, et al., 2024](https://arxiv.org/abs/2406.11794), [NeurIPS 2024](https://openreview.net/forum?id=CNWdWn47IE), [HF repo](https://huggingface.co/datasets/mlfoundations/dclm-baseline-1.0)). [Dataset composition source code for reproduction](https://github.com/mlfoundations/dclm)
+ DCLM-Pool (raw pool, ca. 240T tokens) ([Li, et al., 2024](https://arxiv.org/abs/2406.11794), [NeurIPS 2024](https://openreview.net/forum?id=CNWdWn47IE), [CommonCrawl Repo](https://data.commoncrawl.org/contrib/datacomp/DCLM-pool/index.html)) [Dataset composition source code for reproduction](https://github.com/mlfoundations/dclm)
+ **Nemontron-CC** ([Su, et al., 2024](https://arxiv.org/abs/2412.02595), [CommonCrawl repo](https://data.commoncrawl.org/contrib/Nemotron/Nemotron-CC/index.html))
+ **[Common Pile](common-pile/0.1/README.md)** (raw pool) ([Kandpal, et al., 2025](https://arxiv.org/abs/2506.05209)). [Comma-0.1 training dataset composed from Common Pile, HF repo](https://huggingface.co/datasets/common-pile/comma_v0.1_training_dataset)

## Multilingual Pre-Training Data

+ mC4
+ CulturaX
+ **[HPLT](hplt/README.md)** ([De Gilbert, et al., 2024](https://arxiv.org/abs/2403.14009), [Burchell, et al. (2025)](https://arxiv.org/abs/2503.10267))
+ **FineWeb 2** (https://github.com/huggingface/fineweb-2)
+ MADLAD-400 ([Kudugunta, et al., 2023](https://arxiv.org/abs/2309.04662))
+ TxT360 (https://huggingface.co/spaces/LLM360/TxT360)
+ CommonCorpus (raw pool)

## Parallel Pre-Training Data


## Non-Language Pre-Training Data

### Coding
+ **StarCoder**
+ The Stack v1
+ The Stack v2

### Math and Reasoning
+ Proof-Pile-2 ([Azerbayev et al., 2023](https://arxiv.org/abs/2310.10631))
* MegaMath
* OpenThoughts

## Catalogue Conventions

### Data Organization

The catalogue standardizes on the common JSONlines format, where each document is encoded as a JSON object comprising the document text and available metadata (as defined by each distinct resource), and each JSON object is serialized as a single line, i.e. without internal line breaks.
For premium storage efficiency, all files are compressed using the [Zstandard (ZSTD) protocol](https://datatracker.ietf.org/doc/html/rfc8878).

### Language and Script References

The project standardizes on three-letter language codes from [ISO 639-3](https://en.wikipedia.org/wiki/ISO_639-3) and script (or writing system) codes from [ISO 15924](https://en.wikipedia.org/wiki/ISO_15924), e.g. `ces_Latn` for Czech in Latin script or `srp_Cyrl` for Servian in Cyrillic script.

In April 2025, the project targets [36 distinct languages]((macro-)languages), with 42 internal variants, e.g. different scripts or written standards.

### Corpus Statistics

To obtain reasonably comparable statistics across different resources, the following metrics are defined:

+ **bytes**: on-disk size in native format, e.g. compressed JSON or Parquet
+ **documents**: number of documents, e.g. web pages, papers, books, or similar
+ **segments**: number of paragraph-like units (e.g. `<h1>`, `<p>`, `<li>`, `<pre>` in HTML)
+ **characters**: total volume in Unicode characters (including whitespace)
+ **tokens**: sub-word units according to a common tokenizer (currently [Gemma3](https://gemma-llm.readthedocs.io/en/latest/colab_tokenizer.html))

### Data Sources

Common pre-training datasets typically comprise large components of text derived from web data, e.g. from the Common Crawl, Internet Archive, or other initiatives, and sometimes also include non-web data, e.g. (out-of-copyright) books, government publications, scientific literature, et al.
For various sources, text can be derived from different publishing formats, e.g. HTML documents or PDF files extracted from web crawls.
It would be hard to devise a formal ontology to full ydescribe different data sources.
Instead, catalogue entries provide a free-text, high-level indication of salient information, e.g. the origin of underlying web crawls and other data sources, original document formats, and such.

### Licensing Information

