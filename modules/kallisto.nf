process kallisto_index{

	label 'kallisto'
	
	input: 
	path(fasta_input)

	
	output:
	tuple path(fasta_input), path("${fasta_input.baseName}.index")
	
	script:
	"""
	kallisto index -i ${fasta_input.baseName}.index ${fasta_input}
	"""
}

process kallisto_map{

	label 'kallisto'
	
	input:
	tuple val(pair_id), path(reads1), path(reads2)
	env additional_params
	tuple path(fasta), path(index)
	path(gtf)
	
	output:
	tuple val(pair_id), path("${reads1.baseName}.bam"), emit: bam
	
 	shell:
 	'''
 	kallisto quant -i !{index} -o ./ --gtf !{gtf} ${additional_params} --threads !{params.threads} !{reads1} !{reads2}
	mv pseudoalignments.bam !{reads1.baseName}.bam
 	'''
}
