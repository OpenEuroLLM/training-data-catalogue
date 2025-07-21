# Multilingual MADLAD-400 (Version 1.5; September 2024)

## <a id="background">Background</a>

MADLAD-400 is a 3T token dataset based on Common Crawl containing 419 languages, designed to encompass a larger amount of languages than other datasets created using similar methods. The data construction and preliminary experimental results of training are described in [Kudugunta et al. (2023)](https://arxiv.org/abs/2309.04662). Additional details and download instructions are available on the [HuggingFace MADLAD-400 repository](https://huggingface.co/datasets/allenai/MADLAD-400).

## <a id="sources">Data Sources</a>

The MADLAD-400 dataset is a document-level multilingual dataset derived from Common Crawl (CC). The dataset is available in two deduplicated versions: a 5T token "noisy" dataset and a 3T token "clean" dataset. The 5T dataset is obtained directly from CC, before applying document-level LangID and any of the authors' filtering. On the other hand, the 3T dataset is obtained by filtering with preliminary preprocessing steps, by training a semi-supervised LangID model and applying it, by filtering out questionable content by the authors' judgement, and by applying three additional filters based on language and their "self-audit" quality review.

Additionally, each dataset is released in both a document-level form and a sentence-level form.

## <a id="statistics">Structure & Statistics</a>

(TO-DO depending on type of file, structure, etc.)

## <a id="languages">European Language Support</a>

| **Code(s)** | **Bytes** | **Documents** | **Segments** | **Tokens** | **Characters** |
|-------------|----------:|--------------:|-------------:|-----------:|---------------:|


## <a id="access">Access Information</a>

The primary download site for the data is hosted at [HuggingFace](https://huggingface.co/datasets/allenai/MADLAD-400).

Additionally, the data is directly available for read-only access on the Lumi filesytem.

 - Lumi: TBD!

## <a id="use">Terms of Use</a>

The dataset is released with the [CC-BY-4.0]([https://creativecommons.org/licenses/by/4.0/deed.en](https://creativecommons.org/licenses/by/4.0/legalcode)) license, as stated in the [HuggingFace repository](https://huggingface.co/datasets/allenai/MADLAD-400) and the authors' main [GitHub repository](https://github.com/google-research/google-research/tree/master). Any source files employed from the authors' GitHub repository falls under the [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) license.

## <a id="curator">Catalogue Curators</a>

- Tudor Nicolae Mateiu, Prompsit Language Engineering, tudornm@prompsit.com
