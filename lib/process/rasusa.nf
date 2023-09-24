process Rasusa {

    tag { "$id: $sample" }
    publishDir "$params.outdir/subsample", mode: "symlink", pattern: "*.fq.gz"

    input:
    tuple val(id), path(fastq)
    each sample

    output:
    tuple (val("${id}_${sample}"), path("${id}_${sample}.fq.gz"), emit: reads)

    script:

    """
    rasusa -i $fastq --num $sample -o ${id}_${sample}.fq.gz
    """

}