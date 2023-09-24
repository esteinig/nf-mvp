
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