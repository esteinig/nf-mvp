process Nanoq {

    tag { "$id" }
    publishDir "$params.outdir/read_qc", mode: "symlink", pattern: "${id}_qc.fq.gz"
    publishDir "$params.outdir/read_qc", mode: "copy", pattern: "${id}.json"

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