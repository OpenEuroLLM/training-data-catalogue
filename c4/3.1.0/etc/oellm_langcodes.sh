#!/bin/bash
# Create symlinks in openeurollm/ for OpenEuroLLM target languages.

set -euo pipefail

CATALOGUE_PREFIX=/scratch/project_462000953/training/catalogue
C4_DIR=$CATALOGUE_PREFIX/c4/3.1.0
MULTI=$C4_DIR/multilingual
OELLM=$C4_DIR/openeurollm

# EU official languages
mkdir $OELLM/bul_Cyrl && ln -sr $MULTI/c4-bg.*.json.gz $OELLM/bul_Cyrl/
mkdir $OELLM/ces_Latn && ln -sr $MULTI/c4-cs.*.json.gz $OELLM/ces_Latn/
mkdir $OELLM/dan_Latn && ln -sr $MULTI/c4-da.*.json.gz $OELLM/dan_Latn/
mkdir $OELLM/deu_Latn && ln -sr $MULTI/c4-de.*.json.gz $OELLM/deu_Latn/
mkdir $OELLM/ell_Grek && ln -sr $MULTI/c4-el.*.json.gz $OELLM/ell_Grek/
mkdir $OELLM/eng_Latn && ln -sr $MULTI/c4-en.*.json.gz $OELLM/eng_Latn/
mkdir $OELLM/est_Latn && ln -sr $MULTI/c4-et.*.json.gz $OELLM/est_Latn/
mkdir $OELLM/fin_Latn && ln -sr $MULTI/c4-fi.*.json.gz $OELLM/fin_Latn/
mkdir $OELLM/fra_Latn && ln -sr $MULTI/c4-fr.*.json.gz $OELLM/fra_Latn/
mkdir $OELLM/gle_Latn && ln -sr $MULTI/c4-ga.*.json.gz $OELLM/gle_Latn/
mkdir $OELLM/hun_Latn && ln -sr $MULTI/c4-hu.*.json.gz $OELLM/hun_Latn/
mkdir $OELLM/ita_Latn && ln -sr $MULTI/c4-it.*.json.gz $OELLM/ita_Latn/
mkdir $OELLM/lav_Latn && ln -sr $MULTI/c4-lv.*.json.gz $OELLM/lav_Latn/
mkdir $OELLM/lit_Latn && ln -sr $MULTI/c4-lt.*.json.gz $OELLM/lit_Latn/
mkdir $OELLM/mlt_Latn && ln -sr $MULTI/c4-mt.*.json.gz $OELLM/mlt_Latn/
mkdir $OELLM/nld_Latn && ln -sr $MULTI/c4-nl.*.json.gz $OELLM/nld_Latn/
mkdir $OELLM/pol_Latn && ln -sr $MULTI/c4-pl.*.json.gz $OELLM/pol_Latn/
mkdir $OELLM/por_Latn && ln -sr $MULTI/c4-pt.*.json.gz $OELLM/por_Latn/
mkdir $OELLM/ron_Latn && ln -sr $MULTI/c4-ro.*.json.gz $OELLM/ron_Latn/
mkdir $OELLM/slk_Latn && ln -sr $MULTI/c4-sk.*.json.gz $OELLM/slk_Latn/
mkdir $OELLM/slv_Latn && ln -sr $MULTI/c4-sl.*.json.gz $OELLM/slv_Latn/
mkdir $OELLM/spa_Latn && ln -sr $MULTI/c4-es.*.json.gz $OELLM/spa_Latn/
mkdir $OELLM/swe_Latn && ln -sr $MULTI/c4-sv.*.json.gz $OELLM/swe_Latn/

# Co-official languages in member states
mkdir $OELLM/cat_Latn && ln -sr $MULTI/c4-ca.*.json.gz $OELLM/cat_Latn/
mkdir $OELLM/eus_Latn && ln -sr $MULTI/c4-eu.*.json.gz $OELLM/eus_Latn/
mkdir $OELLM/glg_Latn && ln -sr $MULTI/c4-gl.*.json.gz $OELLM/glg_Latn/

# Candidate EU members
mkdir $OELLM/kat_Geor && ln -sr $MULTI/c4-ka.*.json.gz $OELLM/kat_Geor/
mkdir $OELLM/mkd_Cyrl && ln -sr $MULTI/c4-mk.*.json.gz $OELLM/mkd_Cyrl/
mkdir $OELLM/sqi_Latn && ln -sr $MULTI/c4-sq.*.json.gz $OELLM/sqi_Latn/
mkdir $OELLM/srp_Cyrl && ln -sr $MULTI/c4-sr.*.json.gz $OELLM/srp_Cyrl/
mkdir $OELLM/tur_Latn && ln -sr $MULTI/c4-tr.*.json.gz $OELLM/tur_Latn/
mkdir $OELLM/ukr_Cyrl && ln -sr $MULTI/c4-uk.*.json.gz $OELLM/ukr_Cyrl/

# Scandinavian
mkdir $OELLM/isl_Latn && ln -sr $MULTI/c4-is.*.json.gz $OELLM/isl_Latn/
# mkdir $OELLM/nob_Latn && ln -sr $MULTI/c4-no.*.json.gz $OELLM/nob_Latn/

# Skipped: hrv_Latn (hr not in c4), bos_Latn (bs not in c4)
# Skipped: nor_Latn, nno_Latn (covered by nob_Latn)
