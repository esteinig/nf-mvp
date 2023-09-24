#!/usr/bin/env bash

# All this can be accomplished in a simple script (╯°□°)╯︵ ┻━┻

# This script can be executed with activated environment from 
# the repository top-level folder: `bash scripts/example.sh`

OUTDIR="$PWD/testing"
mkdir -p $OUTDIR

for fq in test/test1.fq.gz test/test2.fq.gz; do
    id=$(basename $fq .fq.gz)
    for subsample in 100 50 10; do
        for ref in test/DAR4145.fasta test/JKD6159.fasta; do
            ref_id=$(basename $ref .fasta)
            pipe_id="${id}_${subsample}_${ref_id}"
            # Subsample -> QC -> Alignment
            rasusa -i $fq --num $subsample | \
                nanoq -l 1000 -q 10 --json --report ${OUTDIR}/${pipe_id}.json | \
                minimap2 -cx map-ont $ref - > ${OUTDIR}/${pipe_id}.paf
        done
    done
done