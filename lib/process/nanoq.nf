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