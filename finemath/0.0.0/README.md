# FineMath

**[DRAFT] (Version 0.0.0; June 2026)**

## <a id="background">Background</a>

FineMath ([Allal et al., 2025](https://arxiv.org/abs/2502.02737)) is a curated collection of mathematical educational content extracted from CommonCrawl, designed to enhance language model capabilities in mathematical reasoning.
Content was scored using a classifier trained on Llama-3.1-70B-Instruct annotations, then deduplicated using MinHash-LSH and decontaminated against standard math benchmarks (GSM8k, MATH, MMLU, ARC).
Additional details are available on the [HuggingFace dataset page](https://huggingface.co/datasets/HuggingFaceTB/finemath).

## <a id="sources">Data Sources</a>

CommonCrawl, with expanded URL coverage from [FineWeb](https://huggingface.co/datasets/HuggingFaceFW/fineweb), [OpenWebMath](https://huggingface.co/datasets/open-web-math/open-web-math), and [InfiMM-WebMath](https://huggingface.co/datasets/Infi-MM/InfiMM-WebMath-40B).
Text extraction used Resiliparse and the OpenWebMath pipeline to better preserve mathematical notation and forum discussions.

## <a id="statistics">Structure & Statistics</a>

The dataset is distributed as 288 Zstd-compressed JSONlines files, amounting to
81 GB on disk.  Files are organised into four partitions: `finemath-3plus` and
`finemath-4plus` (filtered from FineWeb/CommonCrawl URLs) and
`infiwebmath-3plus` and `infiwebmath-4plus` (filtered from InfiMM-WebMath),
each containing a `train` split following the naming pattern
`train-NNNNN-of-NNNNN.jsonl.zst`.  The `-4plus` subsets are higher-quality
subsets of the respective `-3plus` partitions.

<details>
<summary><b>Record Fields</b> (`finemath-3plus` and `finemath-4plus` partitions)</summary>

| **Field** | **Status** |
|-----------|------------|
| `char_count` | required |
| `content_mime_type` | required |
| `crawl` | required |
| `fetch_time` | required |
| `int_score` | required |
| `language` | required |
| `language_score` | required |
| `metadata` | required |
| `score` | required |
| `snapshot_type` | required |
| `text` | required |
| `token_count` | required |
| `url` | required |
| `warc_filename` | required |
| `warc_record_length` | required |
| `warc_record_offset` | required |
</details>

<details>
<summary><b>Record Fields</b> (`infiwebmath-3plus` and `infiwebmath-4plus` partitions)</summary>

| **Field** | **Status** |
|-----------|------------|
| `char_count` | required |
| `int_score` | required |
| `metadata` | required |
| `score` | required |
| `text` | required |
| `token_count` | required |
| `url` | required |

</details>

## <a id="languages">European Language Support</a>

FineMath is English-only.

| **Partition**     |  **Documents** |      **Segments** |         **Tokens** | **Length** |      **Characters** |
|-------------------|---------------:|------------------:|-------------------:|-----------:|--------------------:|
| finemath-3plus    |     21,405,610 |     2,171,327,953 |     38,176,022,740 |     1783.5 |     120,352,354,473 |
| finemath-4plus    |      6,699,493 |       658,736,167 |     10,315,012,594 |     1539.7 |      33,692,440,601 |
| infiwebmath-3plus |     13,882,669 |     1,233,423,949 |     22,194,801,269 |     1598.7 |      75,566,207,319 |
| infiwebmath-4plus |      6,296,212 |       522,135,192 |      9,200,688,027 |     1461.3 |      30,482,806,820 |
| **Total**         | **48,283,984** | **4,585,623,261** | **79,886,524,630** | **1654.5** | **260,093,809,213** |

## <a id="access">Access Information</a>

The primary download site for the data is the [HuggingFace Hub](https://huggingface.co/datasets/HuggingFaceTB/finemath).

On select EuroHPC systems, the data is directly available for read-only access on the local filesystem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/finemath/0.0.0/data/`
+ Leonardo: `/leonardo_work/OELLM_Catalog/training/finemath/0.0.0/data/`

## <a id="use">Terms of Use</a>

The dataset is released under the Open Data Commons Attribution License (ODC-By) v1.0, subject to CommonCrawl's Terms of Use.

## <a id="citation">References</a>

```bibtex
@misc{allal2025smollm2smolgoesbig,
      title={SmolLM2: When Smol Goes Big -- Data-Centric Training of a Small Language Model},
      author={Loubna Ben Allal and Anton Lozhkov and Elie Bakouch and Gabriel Martín Blázquez and Guilherme Penedo and Lewis Tunstall and Andrés Marafioti and Hynek Kydlíček and Agustín Piqueres Lajarín and Vaibhav Srivastav and Joshua Lochner and Caleb Fahlgren and Xuan-Son Nguyen and Clémentine Fourrier and Ben Burtenshaw and Hugo Larcher and Haojun Zhao and Cyril Zakka and Mathieu Morlon and Colin Raffel and Leandro von Werra and Thomas Wolf},
      year={2025},
      eprint={2502.02737},
      archivePrefix={arXiv},
      primaryClass={cs.CL},
      url={https://arxiv.org/abs/2502.02737},
}
```

## <a id="curator">Catalogue Curator</a>

Jindřich Helcl, University of Oslo, <jindrich@uio.no>
