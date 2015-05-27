import nipype.pipeline.engine as pe
import nipype.interfaces.utility as util


def create_community_workflow(wf_name="community_detection_workflow"):

	# new community wokflow instance
	wf = pe.Workflow(name=wf_name)
	
	# populate inputspec node
	inputspec = pe.Node(util.IdentityInterface(fields=['subject', 'template', 'threshold'])															
	
	# main entry point instance
	detect_communities = pe.Node(util.Function(input_names = ['datafile',
															 'template', 
															 'threshold', 
															 'allocated_memory'], 
												output_names = ['out_list'], 
												function = detect_communities), 
												name='detect_communities')


	# connect inputspec node with main function node
	wf.connect(inputspec, 'subject', 
		       detect_communities, 'datafile')

	wf.connect(inputspec, 'template',
		       detect_communities, template)

	wf.connect(inputspec, 'threshold',
		       detect_communities, 'threshold')

	# specify allocated memory from workflow input to function node
	detect_communities.inputs.allocated_memory = allocated_memory

	# populate outputspec noode
	outputspec = pe.Node(util.IdentityInterface(fields= ['community_outputs', 
														 'threshold_matrix',
														 'correlation_matrix',
														 'graph_outputs']),
														 name = 'outputspec')
	# connect outputspec node with main function node
	wf.connect(detect_communities, 'out_list',
			   outputspec, 'community_outputs')

	# return workflow
	return wf

def detect_communities():
