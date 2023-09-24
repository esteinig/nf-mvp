#!/usr/bin/env nextflow 

/** A minimum viable Nextflow pipeline */

include { printHelpAndExit; getReadSamples } from "./lib/utils.nf";
include { subsample_aligner } from "./lib/workflow/subsample.nf";

workflow {
    // Print help message to terminal and exit
    if (params.help) printHelpAndExit();
    
    // Run the subsample alignment workflow
    subsample_aligner(
        Channel.fromPath(params.fastq) | map { file -> tuple(file.getSimpleName(), file) },
        Channel.fromPath(params.fasta), 
        getReadSamples(params.samples)
    )
}

