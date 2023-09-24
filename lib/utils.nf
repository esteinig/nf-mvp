def printHelpAndExit() {

    log.info """
    =======================
    Minimum viable pipeline
    =======================

    Lots of stuff going on
    """.stripIndent();

    System.exit(0);
}

ArrayList<Integer> getSubsampleReads(String subsample) {
    return subsample.split(",").collect { String value -> value.trim() as Integer }
}
