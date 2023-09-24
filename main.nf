#!/usr/bin/env nextflow 

/** A minimum viable Nextflow pipeline */

include { printHelpAndExit; getSubsampleReads } from './lib/utils';
include { subsampleAligner } from './lib/workflow/subsample';

workflow {

    if (params.help) printHelpAndExit();

    subsampleAligner(
        Channel.fromPath(params.fastq),
        Channel.fromPath(params.fasta),
        getSubsampleReads(params.subsample)
    )

}

