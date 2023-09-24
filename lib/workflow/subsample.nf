include { Minimap2 } from "../process/minimap2.nf";
include { Rasusa } from "../process/rasusa.nf";
include { Nanoq } from "../process/nanoq.nf";

// Sub-workflow for read subsampling, quality control and alignment
workflow subsample_aligner {
    take:
        reads                                   // string sample_id, path fastq
        references                              // path fasta 
        samples                                 // integer reads 
    main:
        Rasusa(reads, samples) | Nanoq 
        Minimap2(Nanoq.out.reads, references) | view
    emit:
        reads = Nanoq.out.reads                 // string sample_id, path fastq
        alignments = Minimap2.out.alignment     // string sample_id, string ref_id, path paf
}