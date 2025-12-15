# DataComp-LM (DCLM): Baseline

**[DRAFT] (Version 1.0; July 2024)**

## <a id="background">Background</a>

Data construction and preliminary experimental results are described by [Li, et al., 2024](https://arxiv.org/abs/2406.11794), published in the 2024 Annual Conference on Neural Information Processing Systems ([NeurIPS 2024](https://openreview.net/forum?id=CNWdWn47IE)).

## <a id="sources">Data Sources</a>

The _baseline_ dataset is derived from a much larger [document pool](https://data.commoncrawl.org/contrib/datacomp/DCLM-pool/index.html), and there is extensive [software support](https://github.com/mlfoundations/dclm) for DCLM experimentation.


## <a id="statistics">Structure & Statistics</a>

The dataset is broken up into 100 roughly equal-sized shards, each comprising about 1.6 million documents,
organized in a directory hierarchy with two layers:
`global-shard_01_of_10/local-shard_0_of_10` … `global-shard_10_of_10/local-shard_9_of_10`.
Each subdirectory contains around 280 files.

## <a id="metadata">Available Metadata</a>

| **Field** | **Status** | **Description** |
|-----------|------------|-----------------|
| bff_contained_ngram_count_before_dedupe | required |  |
| language_id_whole_page_fasttext | required |  |
| metadata | required |  |
| previous_word_count | required |  |
| text | required |  |
| url | required |  |
| warcinfo | required |  |
| fasttext_openhermes_reddit_eli5_vs_rw_v2_bigram_200k_train_prob | required |  |

## <a id="languages">European Language Support</a>

| **Code(s)** | **Documents** | **Segments**    | **Tokens**        | **Length** | **Characters**     |
|-------------|--------------:|----------------:|------------------:|-----------:|-------------------:|
| **English** | 2,939,202,307 | 165,477,300,858 | 3,787,521,950,900 | 1,288.6    | 16,519,583,746,304 |


## <a id="access">Access Information</a>

The _baseline_ dataset is [hosted at Hugging Face](https://huggingface.co/datasets/mlfoundations/dclm-baseline-1.0).

## <a id="use">Terms of Use</a>

## <a id="curator">Catalogue Curator</a>

