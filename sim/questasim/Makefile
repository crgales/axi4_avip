# Setting a default TEST as base_test
TEST ?= = axi4_base_test

# Setting the default uvm_verbosity to UVM_MEDIUM
VERBOSITY ?= UVM_MEDIUM

DEFINES ?= +DATA_WIDTH=32

SV_SEED ?= random

TEST_FOLDER ?= $(TEST)

# First target will be executed incase the user doesn't mention
# the target to execute
all: clean compile simulate

# Usage
usage:
	echo ""
	echo "-----------------------------------------------------------------"
	echo "------------------------- Usage ---------------------------------"
	echo ""
	echo "make target <options> <variable>=<value>"
	echo ""
	echo "To compile use:"
	echo "make compile"
	echo ""
	echo "To provide compilation argument:"
	echo "make compile DEFINES=+<macro_name>=<macro_value>"
	echo ""
	echo "make compile DEFINES=+DATA_WIDTH=64"
	echo ""
	echo "To simulate individual test:"
	echo "make simulate TEST=<test_name> VERBOSITY=<VERBOSITY_LEVEL>"
	echo ""
	echo "Example:"
	echo "make simulate TEST=base_test VERBOSITY=UVM_HIGH"
	echo ""
	echo "To run regression:""
	echo "make regression testlist_name=<regression_testlist_name.list>"
	echo ""
	echo "Example:"
	echo "make regression testlist_name=axi4_transfers_regression.list"
	echo ""
	echo "-----------------------------------------------------------------"
	echo "-----------------------------------------------------------------"
	echo ""


# For Assertions use +acc options
#  +cover=becstf
compile: clean
	vlib work
	vlog +cover	+fcover +define$(DEFINES) -l axi4_compile.log -f ../axi4_compile.f
	vopt -o top_opt hdl_top hvl_top -debug +designfile

simulate:
	mkdir $(TEST_FOLDER)
	vsim -c -assertdebug top_opt +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(VERBOSITY) -l $(TEST_FOLDER)/$(TEST).log \
	  -sva -coverage -qwavedb=+signal+class+wavedir=$(TEST_FOLDER) \
	  -do "coverage save -onexit -assert -directive -cvg -codeAll $(TEST_FOLDER)/$(TEST)_coverage.ucdb; run -all; exit"

coverage:
	## TODO(mshariff):
	## # For coverage report in text format
	## #vcover report -text $(test)/$(test)_cov
	# vcover report -file  -byfile -detail -noannotate -option -cvg

	# For coverage report in HTML format
	vcover report -html $(TEST_FOLDER)/$(TEST)_coverage.ucdb -htmldir $(TEST_FOLDER)/html_cov_report -details

	# To open the html coverage report
	# firefox test_folder/html_cov_report/index.html &

	# To open the waveform use the below command
	# vsim -view waveform.wlf &
	#
	# To open the wavefrom with saved signals
	# vsim -view waveform.wlf -do axi4_waves.do &

clean: clean_compile clean_simulate

clean_simulate:
	rm -rf *_test*

clean_compile:
	rm -rf work/ *_compile.log .visualizer visualizer.log design.bin
	rm -rf merged_coverage.ucdb merged_cov_html_report

##
## For Regression and coverage merge
##
regression: clean compile
	# Run simualtion - regression
	python regression_handling.py $(TESTLIST_NAME)
	#	# Get the tests from regression list
	#	grep "_test" ../../src/hvl_top/testlists/axi4_simple_fd_regression.list | grep -v "\#" > reg_list
	#	make simulate test=value #Get the name from regression list
	#	Merge coverage

# For merge to happen, the coverage names for each test must be different
#
merge_cov_report:
	rm -rf merged_coverage.ucdb merged_cov_html_report
	# Merging all the coverage
	vcover merge merged_coverage.ucdb */*.ucdb
	#vcover merge mem_cover mem_cov1 mem_cov2 mem_cov3 mem_cov4 mem_cov5 mem_cov6 mem_cov7 mem_cov8
	vcover report -html merged_coverage.ucdb -htmldir ./merged_cov_html_report -details
	echo ""
	echo "-----------------------------------------------------------------"
	echo "Coverage report: firefox merged_cov_html_report/index.html &"
	echo "-----------------------------------------------------------------"
	echo ""

.IGNORE:
	compile
	simulate

# WE can also use the target where we WANT the silent mode
.SILENT:
	compile
	simulate
	usage
