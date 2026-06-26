# StarCoderData

**[DRAFT] (Version 0.0.0; June 2026)**

## <a id="background">Background</a>

StarCoderData ([Li et al., 2023](https://arxiv.org/abs/2305.06161)) is the training dataset for the StarCoder and StarCoderBase code language models, developed by the BigCode community. It covers 86 programming languages derived from The Stack v1, supplemented by GitHub Issues, Jupyter notebooks, and Git commits. The dataset underwent near-deduplication, PII removal, and benchmark decontamination before release.
Additional details are available on the [HuggingFace dataset page](https://huggingface.co/datasets/bigcode/starcoderdata).

## <a id="sources">Data Sources</a>

Derived from [The Stack v1](https://huggingface.co/datasets/bigcode/the-stack), a collection of GitHub repositories with permissive licenses. Supplementary content (GitHub Issues, Jupyter notebooks, Git commits) was collected from GitHub and similarly filtered and deduplicated.

## <a id="statistics">Structure & Statistics</a>

The dataset is organised into 86 programming language subsets and four special subsets:

- `github-issues-filtered-structured` -- filtered and structured GitHub issue threads
- `git-commits-cleaned` -- cleaned Git commit messages and diffs
- `jupyter-scripts-dedup-filtered` -- deduplicated Jupyter notebook scripts
- `jupyter-structured-clean-dedup` -- structured and cleaned Jupyter notebooks

Files are stored as Zstd-compressed JSONLines files within per-language and per-subset subdirectories.

**Note:** The primary text field in this dataset is `content`, not `text`.

| **Partition** | **Documents** | **Segments** | **Tokens** | **Length** | **Characters** |
|---------------|--------------:|-------------:|-----------:|-----------:|---------------:|
| (all) | 206,642,239 | 22,491,235,350 | 259,636,664,820 | 1,256.8 | 815,450,910,997 |

## <a id="metadata">Available Metadata</a>

<details>
<summary><b>Record Fields</b></summary>

| **Field** | **Status** |
|-----------|------------|
| `content` | required |
| `id` | required |
| `alphanum_fraction` | optional |
| `avg_line_length` | optional |
| `chain_length` | optional |
| `ext` | optional |
| `hexsha` | optional |
| `lang` | optional |
| `license` | optional |
| `max_stars_count` | optional |
| `max_stars_repo_licenses` | optional |
| `max_stars_repo_name` | optional |
| `max_stars_repo_path` | optional |
| `path` | optional |
| `repo_name` | optional |
| `size` | optional |

</details>

## <a id="languages">European Language Support</a>

StarCoderData is programming language data. It does not contain natural language text in the European language sense; code comments and documentation are predominantly English.

## <a id="access">Access Information</a>

The primary download site for the data is the [HuggingFace Hub](https://huggingface.co/datasets/bigcode/starcoderdata).

On select EuroHPC systems, the data is directly available for read-only access on the local filesystem:

+ LUMI: `/appl/local/openeurollm/training/catalogue/starcoder/0.0.0/data/`

## <a id="use">Terms of Use</a>

TODO

### Citation information

```bibtex
@article{li2023starcoder,
  title={StarCoder: may the source be with you!},
  author={Raymond Li and Loubna Ben Allal and Yangtian Zi and Niklas Muennighoff
          and Denis Kocetkov and Chenghao Mou and Marc Marone and Christopher Akiki
          and Jia Li and Jenny Chim and Qian Liu and Evgenii Zheltonozhskii
          and Terry Yue Zhuo and Thomas Wang and Olivier Dehaene and Mishig Davaadorj
          and Joel Lamy-Poirier and Jo\~{a}o Monteiro and Oleh Shliazhko
          and Nicolas Gontier and Nicholas Meade and Armel Zebaze and Ming-Ho Yee
          and Logesh Kumar Umapathi and Jian Zhu and Benjamin Lipkin
          and Muhtasham Oblokulov and Zhiruo Wang and Rudra Murthy
          and Jason Stillerman and Siva Sankalp Patel and Dmitry Abulkhanov
          and Marco Zocca and Manan Dey and Zhihan Zhang and Nour Fahmy
          and Urvashi Bhattacharyya and Wenhao Yu and Swayam Singh
          and Sasha Luccioni and Paulo Villegas and Maxim Kunakov and Fedor Zhdanov
          and Manuel Romero and Tony Lee and Nadav Timor and Jennifer Ding
          and Claire Schlesinger and Hailey Schoelkopf and Jan Ebert and Tri Dao
          and Mayank Mishra and Alex Gu and Jennifer Robinson
          and Carolyn Jane Anderson and Brendan Dolan-Gavitt and Danish Contractor
          and Siva Reddy and Daniel Fried and Dzmitry Bahdanau and Yacine Jernite
          and Carlos Mu\~{n}oz Ferrandis and Sean Hughes and Thomas Wolf
          and Arjun Guha and Leandro von Werra and Harm de Vries},
  year={2023},
  eprint={2305.06161},
  archivePrefix={arXiv},
  primaryClass={cs.CL}
}
```

## <a id="curator">Catalogue Curator</a>

Jindřich Helcl, University of Oslo, <jindrich@uio.no>
