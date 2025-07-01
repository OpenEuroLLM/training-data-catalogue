# Conventions Used in the OpenEuroLLM Training Data Catalogue

## Data Organization

The catalogue standardizes on the common JSONlines format, where each document is encoded as a JSON object comprising the document text and available metadata (as defined by each distinct resource), and each JSON object is serialized as a single line, i.e. without internal line breaks.
For premium storage efficiency, all files are compressed using the [Zstandard (ZSTD) protocol](https://datatracker.ietf.org/doc/html/rfc8878).

## Language and Script References

The project standardizes on three-letter language codes from [ISO 639-3](https://en.wikipedia.org/wiki/ISO_639-3) and script (or writing system) codes from [ISO 15924](https://en.wikipedia.org/wiki/ISO_15924), e.g. `ces_Latn` for Czech in Latin script or `srp_Cyrl` for Servian in Cyrillic script.

In April 2025, the project targets [36 distinct languages]((macro-)languages), with 42 internal variants, e.g. different scripts or written standards.

## Corpus Statistics

To obtain reasonably comparable statistics across different resources, the following metrics are defined:

+ **bytes**: on-disk size in native format, e.g. compressed JSON or Parquet
+ **documents**: number of documents, e.g. web pages, papers, books, or similar
+ **segments**: number of paragraph-like units (e.g. `<h1>`, `<p>`, `<li>`, `<pre>` in HTML)
+ **characters**: total volume in Unicode characters (including whitespace)
+ **tokens**: sub-word units according to a common tokenizer (currently [Gemma3](https://gemma-llm.readthedocs.io/en/latest/colab_tokenizer.html))

## Data Sources

Common pre-training datasets typically comprise large components of text derived from web data, e.g. from the Common Crawl, Internet Archive, or other initiatives, and sometimes also include non-web data, e.g. (out-of-copyright) books, government publications, scientific literature, et al.
For various sources, text can be derived from different publishing formats, e.g. HTML documents or PDF files extracted from web crawls.
It would be hard to devise a formal ontology to full ydescribe different data sources.
Instead, catalogue entries provide a free-text, high-level indication of salient information, e.g. the origin of underlying web crawls and other data sources, original document formats, and such.

## Licensing Information

