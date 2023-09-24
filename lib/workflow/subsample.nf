include { Rasusa } from '../process/rasusa';
include { Nanoq } from '../process/nanoq';
include { Minimap2 } from '../process/minimap2';

workflow subsampleAligner {
    take:
        reads
        references
        subsamples
    main:

        // Pipeline steps
        Rasusa(reads, subsamples)
        Nanoq(Rasusa.out.reads)
        Minimap2(Nanoq.out.reads, references)

        // Debug statement to check outputs
        if (params.debug) Minimap2.out | view

    emit:
        reads = Nanoq.out.reads
        alignment = Minimap2.out.alignment
}
