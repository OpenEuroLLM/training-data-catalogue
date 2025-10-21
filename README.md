# OpenEuroLLM Catalogue of LLM Training Data


## Background

There is a bit of a growth industry in (pre-)training data preparation for LLM development.
This page aims to offer navigational help in the dataset landscape, essentially providing a structured ‘catalogue’ of available resources.
Originally, the catalogue is constructed for internal use in the [OpenEuroLLM](https://openeurollm.eu/) initiative, i.e. will put most emphasis on datasets used in the project.
At the same time, we hope that this overview may become useful to others and can grow into a community-supported resource.
The catalogue is accompanied by a curated collection of (a subset of) LLM (pre-)training datasets that are publicly made available (read-only) on multiple EuroHPC systems, currently:

+ LUMI: `/appl/local/openeurollm/training/catalogue/`
+ Leonardo: `/leonardo_work/OELLM_Catalog/training/`

To nominate additional resources for inclusion in the catalogue or discuss specifics of emerging entries, please create a [GitHub issue on this repository](https://github.com/OpenEuroLLM/training-data-catalogue/issues).


## (Mostly) English Pre-Training Data

+ C4 ([Raffel, et al., 2019](https://arxiv.org/abs/1910.10683))
+ The Pile ([Gao, et al., 2020](https://arxiv.org/abs/2101.00027), [Biderman, et al., 2022](https://arxiv.org/abs/2201.07311))
+ RefinedWeb
+ RedPajama
+ SlimPajama
+ **[DCLM](dclm/1.0/README.md)** ([Li, et al., 2024](https://arxiv.org/abs/2406.11794))
+ Dolma
+ **[FineWeb 1](fineweb/1.4.0/README.md)** ([Penedo, et al., 2024](https://arxiv.org/abs/2406.17557))
+ **[Nemotron-CC](nemotron-cc/1.0/README.md)** ([Su, et al., 2024](https://arxiv.org/abs/2412.02595))
+ **[Common Pile](common-pile/0.1/README.md)** ([Kandpal, et al., 2025](https://arxiv.org/abs/2506.05209))

## Multilingual Pre-Training Data

+ mC4
+ CulturaX ([Nguyen, et al., 2024](https://aclanthology.org/2024.lrec-main.377/))
+ **[HPLT](hplt/2.0/README.md)** ([De Gilbert, et al., 2024](https://arxiv.org/abs/2403.14009), [Burchell, et al. (2025)](https://arxiv.org/abs/2503.10267))
+ **[FineWeb 2](fineweb/2.1.0/README.md)** (https://github.com/huggingface/fineweb-2)
+ **[FinePDFs](finepdfs/1.1.0/README.md)** (https://huggingface.co/datasets/HuggingFaceFW/finepdfs)
+ **[MADLAD-400](madlad-400/1.0/README.md)** ([Kudugunta, et al., 2023](https://arxiv.org/abs/2309.04662))
+ TxT360 (https://huggingface.co/datasets/LLM360/TxT360)
+ Common Corpus (https://huggingface.co/blog/Pclanglais/common-corpus)


## Parallel Pre-Training Data


## Code Pre-Training Data

+ StarCoder
+ The Stack

## Math and Reasoning Pre-Training Data

+ Proof-Pile-2 ([Azerbayev et al., 2023](https://arxiv.org/abs/2310.10631))
+ MegaMath
+ OpenThoughts


## Catalogue Conventions

### Life-Cycle of Entries

Active use and public access to the catalogue calls for well-defined procedures – by-laws and governance structures – for (a) selection of additional datasets to ingest and (b) deprecation and removal of “out-of-date” resources over time.
For example, Hugging Face regularly provides updates to the FineWeb datasets, e.g. versions 1.0.0, 1.1.0, …, 1.4.0 between May 2024 and July 2025 for the original English partition.
Each full version requires about 25 terabytes of storage.
It seems plausible to expect that new experimentation should start from the latest version of each dataset in the catalogue, but some users might be in the middle of a series of experiments, based on an earlier version, and would be inconvenienced by abrupt loss of access to this data.
Thus, we anticipate that the catalogue can provide multiple versions of a dataset, where superseded versions will be flagged as deprecated and removed after a grace period of, for example, three to six months.

Each catalogue entry is tagged with one of three status values:

+ **draft** [D]:
+ **published** [P]:
+ **deprecated** [E]:

### Data Organization

The catalogue standardizes on the common JSONlines format, where each document is encoded as a JSON object comprising the document text and available metadata (as defined by each distinct resource), and each JSON object is serialized as a single line, i.e. without internal line breaks.
For premium storage efficiency, all files are compressed using the [Zstandard (ZSTD) protocol](https://datatracker.ietf.org/doc/html/rfc8878).

### Language and Script References

The project standardizes on three-letter language codes from [ISO 639-3](https://en.wikipedia.org/wiki/ISO_639-3) and script (or writing system) codes from [ISO 15924](https://en.wikipedia.org/wiki/ISO_15924), e.g. `ces_Latn` for Czech in Latin script or `srp_Cyrl` for Serbian in Cyrillic script.

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

Catalogue entries seek to summarize legal aspects of datasets such as their available information about licensing and terms of use.
This information is intended to help prospective users determine which training data is most suitable for their specific use case.
Inclusion of individual datasets in the OpenEuroLLM catalogue, in and of itself, does not constitute a judgment by the project regarding the technical or legal suitability of these resources for LLM development and release.

The catalogue emphasizes “open” datasets with minimal legal uncertainty in using them for LLM R&D.
To this end, the following key criteria inform the consideration of resources to be included in the catalogue:
+ datasets must be generally accessible, for example by public download;
+ datasets must provide clear terms of use or licensing information; and
+ datasets must not explicitly restrict modification or use for LLM training.

Users of the OpenEuroLLM Training Data Catalogue must adhere to applicable EU regulations, such as the provisions in the [Copyright Directive](http://data.europa.eu/eli/dir/2019/790/oj), [AI Act](https://artificialintelligenceact.eu/the-act/), and compliance measures suggested in the recent [General-Purpose AI Code of Practice](https://digital-strategy.ec.europa.eu/en/policies/contents-code-gpai).
