#!/usr/bin/env nextflow 

/** A minimum viable Nextflow pipeline */

params.help  = false;
params.debug = false;
params.fastq = "test/*.fq.gz"
params.fasta = "test/*.fasta"
params.outdir = "mvp-result"
params.subsample = "100,50,10"

include { printHelpAndExit; getSubsampleReads } from './lib/utils';
include { subsampleAligner } from './lib/workflow/subsample';

workflow {

    if (params.help) printHelpAndExit();

    subsampleAligner(
        Channel.fromPath(params.fastq) | map { file -> tuple(file.getSimpleName(), file) },
        Channel.fromPath(params.fasta),
        getSubsampleReads(params.subsample)
    )

}

