# [DRAFT] English Common Pile

**(Version 0.1; June 2025)**

## <a id="background">Background</a>

The Comma training dataset provides high-quality text for LLM pre-training
using only public domain and openly licensed content.  The data construction
and experimental results are described by [Kandpal et al.,
2025](https://arxiv.org/abs/2506.05209).  The Comma dataset is built from the
8TB Common Pile v0.1 through filtering, deduplication, and rebalancing.
Additional details are available in the paper and on the dataset [Hugging Face
page](https://huggingface.co/datasets/common-pile/comma_v0.1_training_dataset).

## <a id="sources">Data Sources</a>

The dataset comprises text from 30 sources spanning scientific publications,
online discussions, government documents, historical books, educational
materials, code repositories, and web content.  Text extraction and
preprocessing used the [Dolma](https://github.com/allenai/dolma) toolkit.
Language identification was performed with [FastText](https://fasttext.cc/).
Quality filtering included toxicity classifiers, PII redaction, OCR error
detection, and heuristic filters for boilerplate removal. Code data was
filtered using language-specific quality classifiers to retain educational and
well-documented code. Global fuzzy deduplication using bloom filters removed
documents sharing over 90% of 20-grams.

## <a id="statistics">Structure & Statistics</a>

The dataset is distributed as 1,984 Zstd-compressed JSONlines files across 30
source directories, amounting to a total of 421 GB on disk.  Each source is
distributed across 64 shards, e.g. `arxiv_abstracts/0.jsonl.zst` …
`arxiv_abstracts/63.jsonl.zst`.  Each line in the JSONlines files contains a
JSON object with a `text` field providing the document content.


## <a id="languages">European Language Support</a>

| **Code(s)** | **Bytes** | **Documents** | **Segments** | **Tokens** | **Characters** |
|-------------|----------:|--------------:|-------------:|-----------:|---------------:|


## <a id="access">Access Information</a>

The data in the 0.1 release is available in different 'packages', (a) the
[complete Common
Pile](https://huggingface.co/collections/common-pile/common-pile-v01-raw-data-6826b454a5a6a445d0b51b37),
(b) a [filtered
sub-set](https://huggingface.co/collections/common-pile/common-pile-v01-filtered-data-68300bb0a946d10dda697663),
and (c) a "[slightly modified and consolidated
version](https://huggingface.co/datasets/common-pile/comma_v0.1_training_dataset)"
used to train the Comma v0.1 language models.

## <a id="use">Terms of Use</a>

This dataset follows the definition of "openly licensed" given in Section 2 of
[Kandpal et al., 2025](https://arXiv.org/abs/2506.05209). It contains only data
that is either in the public domain or released under licenses that meet the
Open Knowledge Foundation's [Open Definition
2.1](https://opendefinition.org/od/2.1/). Included licenses comprise Creative
Commons licenses that allow derivatives and commercial use (CC BY, CC BY-SA),
and permissive software/content licenses certified by the [Blue Oak
Council](https://blueoakcouncil.org/list). Licenses with non-commercial (NC) or
no-derivatives (ND) restrictions are excluded.  Licenses with non-commercial or
no-derivatives restrictions are excluded. The dataset was curated with care,
omitting sources with unclear or collection-level licensing and synthetic text
from models trained on unlicensed data.

### <a id="use">Citation Information</a>
```bibtex
@article{kandpal2025common,
  title={{The Common Pile v0.1: An 8TB Dataset of Public Domain and Openly Licensed Text}},
  author={Nikhil Kandpal and Brian Lester and Colin Raffel and Sebastian Majstorovic and Stella Biderman and Baber Abbasi and Luca Soldaini and Enrico Shippole and A. Feder Cooper and Aviya Skowron and Shayne Longpre and Lintang Sutawika and Alon Albalak and Zhenlin Xu and Guilherme Penedo and Loubna Ben  and Elie Bakouch and John David  and Honglu Fan and Dashiell Stander and Guangyu Song and Aaron Gokaslan and John Kirchenbauer and Tom Goldstein and Brian R and Bhavya Kailkhura and Tyler Murray},
  journal={arXiv preprint},
  year={2025}
}
```

## <a id="curator">Catalogue Curator</a>

Jindřich Helcl, University of Oslo, <jindrich@ifi.uio.no>
