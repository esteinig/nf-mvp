#!/usr/bin/env nextflow 

/** A minimum viable Nextflow pipeline */

// IO 

params.help  = false;
params.fastq = "test/*.fq.gz"
params.fasta = "test/*.fasta"
params.outdir = "mvp-result"
params.subsample = [100, 50, 10]

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
    
    tag { "$id: $subsample" }
    publishDir "$params.outdir/rasusa/$subsample", mode: "symlink", pattern: "*.fq.gz"

    input:
    tuple val(id), path(fastq)
    each subsample

    output:
    tuple (val(id), path("${id}_${subsample}.fq.gz"), emit: reads)

    script:

    """
    rasusa -i $fastq --num $subsample -o ${id}_${subsample}.fq.gz
    """
}

process Nanoq {

    tag { "$id" }
    publishDir "$params.outdir/nanoq", mode: "symlink", pattern: "*.fq.gz"
    publishDir "$params.outdir/nanoq", mode: "copy", pattern: "*.json"

    input:
    tuple val(id), path(fastq)

    output:
    tuple (val(id), path("${id}_qc.fq.gz"), emit: reads)
    path("${id}.json")

    script:

    """
    nanoq -i $fastq -l 1000 -q 10 --json --report ${id}.json > ${id}_qc.fq.gz
    """
}

process Minimap2 {
    
    tag { "$id: $ref" }
    publishDir "$params.outdir/minimap2/$ref", mode: "symlink", pattern: "*.paf"

    input:
    tuple val(id), path(fastq)
    each path(fasta)

    output:
    tuple (val(id), val(ref), path("${id}.${ref}.paf"), emit: alignment)

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
    references = Channel.fromPath(params.fasta)

    // Pipeline steps
    Rasusa(reads, params.subsample)
    Nanoq(Rasusa.out.reads)
    Minimap2(Nanoq.out.reads, references) | view

}