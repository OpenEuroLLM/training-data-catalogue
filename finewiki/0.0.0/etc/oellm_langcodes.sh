#!/bin/bash
# Create symlinks in openeurollm/ for OpenEuroLLM target languages.

set -euo pipefail

CATALOGUE_PREFIX=/scratch/project_462000953/training/catalogue
FINEWIKI_DIR=$CATALOGUE_PREFIX/finewiki/0.0.0
DATA=$FINEWIKI_DIR/data
OELLM=$FINEWIKI_DIR/openeurollm

mkdir $OELLM

# EU Official Languages
ln -sr $DATA/bgwiki $OELLM/bul_Cyrl
ln -sr $DATA/cswiki $OELLM/ces_Latn
ln -sr $DATA/dawiki $OELLM/dan_Latn
ln -sr $DATA/dewiki $OELLM/deu_Latn
ln -sr $DATA/elwiki $OELLM/ell_Grek
ln -sr $DATA/enwiki $OELLM/eng_Latn
ln -sr $DATA/etwiki $OELLM/est_Latn
ln -sr $DATA/fiwiki $OELLM/fin_Latn
ln -sr $DATA/frwiki $OELLM/fra_Latn
ln -sr $DATA/gawiki $OELLM/gle_Latn
ln -sr $DATA/hrwiki $OELLM/hrv_Latn
ln -sr $DATA/huwiki $OELLM/hun_Latn
ln -sr $DATA/itwiki $OELLM/ita_Latn
ln -sr $DATA/lvwiki $OELLM/lav_Latn
ln -sr $DATA/ltwiki $OELLM/lit_Latn
ln -sr $DATA/mtwiki $OELLM/mlt_Latn
ln -sr $DATA/nlwiki $OELLM/nld_Latn
ln -sr $DATA/plwiki $OELLM/pol_Latn
ln -sr $DATA/ptwiki $OELLM/por_Latn
ln -sr $DATA/rowiki $OELLM/ron_Latn
ln -sr $DATA/skwiki $OELLM/slk_Latn
ln -sr $DATA/slwiki $OELLM/slv_Latn
ln -sr $DATA/eswiki $OELLM/spa_Latn
ln -sr $DATA/svwiki $OELLM/swe_Latn

# Co-official Languages in Member States
ln -sr $DATA/cawiki $OELLM/cat_Latn
ln -sr $DATA/euwiki $OELLM/eus_Latn
ln -sr $DATA/glwiki $OELLM/glg_Latn

# Candidate EU Members
ln -sr $DATA/bswiki $OELLM/bos_Latn
ln -sr $DATA/kawiki $OELLM/kat_Geor
ln -sr $DATA/mkwiki $OELLM/mkd_Cyrl
ln -sr $DATA/sqwiki $OELLM/sqi_Latn
ln -sr $DATA/srwiki $OELLM/srp_Cyrl
ln -sr $DATA/trwiki $OELLM/tur_Latn
ln -sr $DATA/ukwiki $OELLM/ukr_Cyrl

# Closely Associated Scandinavian
ln -sr $DATA/iswiki $OELLM/isl_Latn
ln -sr $DATA/nowiki $OELLM/nor_Latn
