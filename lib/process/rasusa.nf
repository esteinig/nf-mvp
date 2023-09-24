process Rasusa {
    
    tag { "$id: $subsample" }
    publishDir "$params.outdir/rasusa/$subsample", mode: "symlink", pattern: "*.fq.gz"

    input:
    tuple val(id), path(fastq)
    each subsample

    output:
    tuple (val("${id}_${subsample}"), path("${id}_${subsample}.fq.gz"), emit: reads)

    script:

    """
    rasusa -i $fastq --num $subsample -o ${id}_${subsample}.fq.gz
    """
}