## <a id="background">Background</a>

The German Commons provides the largest collection of openly licensed German text for LLM pre-training.
The data construction and corpus statistics are described by
[Gienapp et al., 2025](https://arxiv.org/abs/2510.13996).
The dataset comprises 154.6 billion tokens across 35.8 million documents
spanning seven thematic domains: web, political, legal, news, economics, cultural, and scientific text.
This catalogue entry corresponds to commit
[d54ba51](https://huggingface.co/datasets/coral-nlp/german-commons/commit/d54ba51)
from the Hugging Face repository.

Additional details are available in the paper and on the dataset
[Hugging Face page](https://huggingface.co/datasets/coral-nlp/german-commons).

## <a id="sources">Data Sources</a>

The dataset comprises text from national libraries, research infrastructures,
academic institutions, government agencies, and open-source platforms.
All sources have explicit licenses that meet
[Open Knowledge Foundation's Open Definition 2.1](https://opendefinition.org/od/2.1/).
The processing pipeline uses [FastText](https://fasttext.cc/) for language identification,
[Presidio](https://github.com/microsoft/presidio) for PII removal,
and LSH bloom filters for deduplication.
The pipeline can be reproduced using the [llmdata library](https://github.com/coral-nlp/llmdata).

## <a id="statistics">Structure & Statistics</a>

The dataset is distributed as 464 Zstd-compressed JSONlines files across seven thematic domains,
amounting to a total of 127 GB on disk.
Files are organized into domain directories:
`cultural` (85 files), `economic` (1 file), `legal` (16 files), `news` (259 files),
`political` (10 files), `scientific` (7 files), and `web` (86 files).
Each domain directory contains subdirectories for individual source datasets.

**Record Fields**

| **Field** | **Status** |
|-----------|------------|
| `id` | required |
| `license` | required |
| `num_tokens` | required |
| `ocr_score` | required |
| `perplexity` | required |
| `source` | required |
| `subset` | required |
| `text` | required |

## <a id="languages">European Language Support</a>

German Commons is primarily in German.

| **Partition** | **Bytes** | **Documents** | **Segments** | **Tokens** | **Characters** |
|-------------|----------:|--------------:|-------------:|-----------:|---------------:|
| cultural | 48,509,216,480 | 6,132,403 | 525,420,382 | 42,760,608,767 | 129,808,115,406 |
| economic | 40,847,644 | 57,214 | 389,585 | 78,983,138 | 280,414,531 |
| legal | 1,734,965,631 | 514,726 | 14,106,866 | 2,108,017,752 | 7,589,298,757 |
| news | 66,914,707,836 | 13,266,052 | 13,631,250 | 55,516,067,223 | 180,444,548,404 |
| political | 1,982,247,068 | 257,888 | 11,188,211 | 2,554,630,956 | 9,124,877,750 |
| scientific | 686,717,366 | 93,689 | 4,133,295 | 571,722,952 | 2,200,608,997 |
| web | 16,250,799,370 | 15,456,562 | 42,107,566 | 12,783,548,834 | 52,379,121,614 |
| **Total** | 136,119,501,395 | 35,778,534 | 610,977,155 | 116,373,579,622 | 381,826,985,459 |

## <a id="use">Terms of Use</a>
All documents in the German Commons are distributed under licenses meeting the
[Open Knowledge Foundation's Open Definition 2.1](https://opendefinition.org/od/2.1/).
Accepted licenses include public domain equivalent (CC0-1.0, Unlicense, MIT-0, 0BSD),
attribution licenses (MIT, BSD variants, Apache, CC-BY),
and copyleft licenses (CC-BY-SA-4.0, EUPL-1.2, Artistic-2.0).
All licenses permit redistribution, modification, and commercial use.
Each document is tagged with its SPDX-canonical license URL linking to the original license text.


### <a id="use">Citation Information</a>
```bibtex
@article{gienapp:2025d,
    title        = {{The German Commons -- 154 Billion Tokens of Openly Licensed Text for German Language Models}},
    author       = {Lukas Gienapp and
                    Christopher Schr\"oder and
                    Stefan Schweter and
                    Christopher Akiki and
                    Ferdinand Schlatt and
                    Arden Zimmermann and
                    Phillipe Gen\^et and
                    Martin Potthast},
    year         = 2025,
    month        = oct,
    journal      = {CoRR},
    volume       = {abs/2510.13996},
    url          = {https://arxiv.org/abs/2510.13996}
}
```

## <a id="curator">Catalogue Curator</a>

Jindřich Helcl, University of Oslo, <jindrich@ifi.uio.no>
