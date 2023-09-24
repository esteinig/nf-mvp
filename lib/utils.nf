def printHelpAndExit() {

    log.info """
    =======================
    Minimum viable pipeline
    =======================

    ${workflow.manifest.description} (v${workflow.manifest.version})
    """.stripIndent();

    System.exit(0);
}

ArrayList<Integer> getSubsampleReads(String subsample) {
    return subsample.split(",").collect { String value -> value.trim() as Integer }
}
