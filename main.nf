#!/usr/bin/env nextflow 

/** A minimum viable Nextflow pipeline */

// IO 

params.help  = false;
params.fastq = "test/*.fq.gz"
params.fasta = "test/DAR4145.fasta"
params.outdir = "mvp-result"
params.subsample = 100

def printHelpAndExit() {

    log.info """
    =======================
    Minimum viable pipeline
    =======================

    Lots of stuff going on
    """.stripIndent();

    System.exit(0);
}

process Rasusa {
    
    tag { "$id: $params.subsample" }

    input:
    tuple val(id), path(fastq)

    output:
    tuple val(id), path("${id}_subsample.fq.gz")

    script:

    """
    rasusa -i $fastq --num $params.subsample -o ${id}_subsample.fq.gz
    """
}

process Nanoq {

    tag { "$id" }

    input:
    tuple val(id), path(fastq)

    output:
    tuple val(id), path("${id}_qc.fq.gz")

    script:

    """
    nanoq -i $fastq -l 1000 -q 10 --json --report ${id}.json > ${id}_qc.fq.gz
    """
}

process Minimap2 {
    
    tag { "$id: $ref" }

    input:
    tuple val(id), path(fastq)
    path(fasta)

    output:
    tuple val(id), val(ref), path("${id}.${ref}.paf")

    script:

    ref = fasta.getSimpleName()

    """
    minimap2 -cx map-ont $fasta $fastq > ${id}.${ref}.paf
    """
}


workflow {

    if (params.help) printHelpAndExit();

    // Stage input files 
    reads = Channel.fromPath(params.fastq) | map { file -> tuple(file.getSimpleName(), file) }
    reference = file(params.fasta)

    // Pipeline steps
    Rasusa(reads) | Nanoq
    Minimap2(Nanoq.out, reference) | view

}