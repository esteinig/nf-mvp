process Minimap2 {
    
    tag { "$id: $ref" }
    publishDir "$params.outdir/alignment/${ref}", mode: "symlink", pattern: "${id}.paf"

    input:
    tuple val(id), path(fastq)
    each path(fasta)

    output:
    tuple (val(id), val(ref), path("${id}.paf"), emit: alignment)

    script:

    ref = fasta.getSimpleName()

    """
    minimap2 -cx map-ont $fasta $fastq > ${id}.paf
    """

}