# Conventions Used in the OpenEuroLLM Training Data Catalogue

## Language and Script References

The project standardizes on three-letter language codes from [ISO 639-3](https://en.wikipedia.org/wiki/ISO_639-3) and script (or writing system) codes from [ISO 15924](https://en.wikipedia.org/wiki/ISO_15924), e.g. `ces_Latn` for Czech in Latin script or `srp_Cyrl` for Servian in Cyrillic script.

In April 2025, the project targets [36 distinct languages]((macro-)languages), with 42 internal variants, e.g. different scripts or written standards.

## Corpus Statistics

To obtain reasonably comparable statistics across different resources, the following metrics are defined:

+ **bytes**: on-disk size in native format, e.g. compressed JSON or Parquet
+ **documents**: number of documents, e.g. web pages, papers, books, or similar
+ **segments**: number of paragraph-like units (e.g. `<h1>`, `<p>`, `<li>`, `<pre>` in HTML)
+ **characters**: total volume in Unicode characters (including whitespace)
+ **tokens**: sub-word units according to a common tokenizer (currently Gemma3)

## Licensing Information

