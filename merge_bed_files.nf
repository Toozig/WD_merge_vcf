#!/usr/bin/env nextflow

nextflow.enable.dsl = 2



// List of bed files to merge
params.bedFiles = ''
// Output name for the merged bed file
params.outputName = ''
// Example bed files
params.exampleBedFiles = './example/input/seq1.bed ./example/input/seq2.bed ./example/input/seq3.bed'
// Example output name
params.exampleOutputName = './example/output/merged.bed'



// Define your workflow process here
process mergeBedFiles {
    container 'pegi3s/bedtools'
    input:
    path BedFiles
    val outputFileName

    output:
    path outputFile
    path outputLog
    script:

    outputFile = "${outputFileName}.bed"
    outputLog = "${outputFileName}.log"
    """
    merge_bed_files.sh ${BedFiles.join(' ')} ${outputFileName}
    """
}


process writeJson {
    input:
    path outputFile
    path logFile

    output:
     //path  jsonFile

    script:
    """
    echo "need to do!"
    """
}

// Define your workflow here
workflow bedMergeWorkflow {
    // take:
    // bedFiles
    
    main:
    // bedFile = Channel.from(params.bedFiles)
    // outputName = Channel.from(params.outputName)
    // create channel for each input file 
    // bedFile.view()
    bedFiles = params.bedFiles.split(' ')
    bedChannels = Channel.fromPath(bedFiles[0])
    for (i in 1..<bedFiles.size()) {
        bedChannels = bedChannels.merge(Channel.fromPath(bedFiles[i]))
    }
    bedChannels.view()

    mergeBedFiles(bedChannels, params.outputName) | writeJson

    //emit:
    // output = mergeBedFiles.outputFile
    // json = writeJson.jsonFile
}


workflow {
    // bedFile = Channel.from(params.bedFiles)
    // outputName = Channel.from(params.outputName)
    bedMergeWorkflow()

}
