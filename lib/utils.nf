// Print the help message
def printHelpAndExit() {

    log.info """
    =======================
    Minimum Viable Pipeline
    =======================

    ${workflow.manifest.description} (v${workflow.manifest.version})
    """.stripIndent();

    System.exit(0);
}

// Split input comma-delimited string for subsample pipeline
ArrayList<Integer> getReadSamples(sample_str) {
    return sample_str.split(",").collect { String value -> value.trim() as Integer }
}
