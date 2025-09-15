# Makefile for AXI4 AVIP
# Author: Muhammad Shahrukh
MODE ?= puresim

# Project Settings
AXI4_AVIP_BASE_DIR ?= ${PWD}/../..
export AXI4_AVIP_BASE_DIR

# Tool Settings
VLOG_puresim = vlog
VLIB_puresim = vlib

VLOG_veloce = velanalyze
VLIB_veloce = velib

# Test Settings
# Setting a default TEST as base_test
TEST ?= axi4_write_read_test

# Setting the default uvm_verbosity to UVM_MEDIUM
UVM_VERBOSITY ?= UVM_MEDIUM

## For randomized seed
# TODO(mshariff): 
#Add this line after -sva 
#-sv_seed random 

# Setting the default seed value to random
SEED ?= random

# Setting the default TEST folder to TEST name 
TEST_FOLDER ?= $(TEST)

# First target will be executed incase the user doesn't mention
# the target to execute
# In this case, usage will be executed
# Usage
usage:
	echo "";
	echo "-----------------------------------------------------------------";
	echo "------------------------- Usage ---------------------------------";
	echo "";
	echo "make target <options> <variable>=<value>";
	echo "";
	echo "To compile use:";
	echo "make compile";
	echo "";
	echo "To provide compilation argument:";
	echo "make compile";
	echo "";
	echo "To simulate individual TEST:"
	echo "make simulate TEST=<test_name> uvm_verbosity=<VERBOSITY_LEVEL>";
	echo "";
	echo "Example:":
	echo "make simulate TEST=base_test uvm_verbosity=UVM_HIGH";
	echo "";
	echo "To provide seed number (default is random):"
	echo "make simulate TEST=<test_name> uvm_verbosity=<VERBOSITY_LEVEL> seed=<value>";
	echo "";
	echo "To run regression:"
	echo "make regression testlist_name=<regression_testlist_name.list>";
	echo "";
	echo "Example:":
	echo "make regression testlist_name=axi4_transfers_regression.list";
	echo "";
	echo "-----------------------------------------------------------------";
	echo "-----------------------------------------------------------------";
	echo "";

all: clean compile simulate

common_lib:
	mkdir -p libs
	vlib libs/common_lib
	vmap common_lib libs/common_lib

common_comp: common_lib
	$(VLOG_$(MODE)) -work common_lib -l axi4_common_compile.log $(AXI4_AVIP_BASE_DIR)/src/globals/axi4_globals_pkg.sv

hdl_lib:
	mkdir -p libs
	vlib libs/hdl_work
	vmap hdl_work libs/hdl_work

hdl_comp: hdl_lib
	$(VLOG_$(MODE)) -work hdl_work -L common_lib -l axi4_hdl_compile.log -f ../axi4_hdl_compile.f

hvl_lib:
	mkdir -p libs
	vlib libs/hvl_work
	vmap hvl_work libs/hvl_work

hvl_comp: hvl_lib
	$(VLOG_$(MODE)) -work hvl_work -L common_lib -l axi4_hvl_compile.log -f ../axi4_hvl_compile.f
# For Assertions use +acc options
#  +cover=becstf
compile: common_comp hdl_comp hvl_comp
	vopt -quiet -work hvl_work -L common_lib -o top_opt hvl_top hdl_work.hdl_top -l hvl_opt.log +designfile -debug

simulate:
	mkdir -p $(TEST_FOLDER)
	vsim -quiet -work hvl_work top_opt \
	-sv_seed $(SEED) \
	-assertdebug \
	+UVM_TESTNAME=$(TEST) \
	+UVM_VERBOSITY=$(UVM_VERBOSITY) \
	-l $(TEST_FOLDER)/$(TEST).log \
	-sva \
	-coverage \
	-c -do "coverage save -onexit -assert -directive -cvg -codeAll $(TEST_FOLDER)/$(TEST)_coverage.ucdb; run -all; exit"


	## TODO(mshariff): 
	## # For coverage report in text format 
	## #vcover report -text $(TEST)/$(TEST)_cov
	# -c -do "coverage save -onexit -assert -directive -cvg -codeAll $(TEST)/coverage.ucdb; coverage report -file $(teset)/coverage.txt -byfile -detail -noannotate -option -directive -cvg -details -verbose; run -all; exit" \
	# vcover report -file  -byfile -detail -noannotate -option -cvg

	# For coverage report in HTML format 
	# vcover report -html $(TEST_FOLDER)/$(TEST)_coverage.ucdb -htmldir $(TEST_FOLDER)/html_cov_report -details

	# To open the html coverage report
	# firefox TEST_FOLDER/html_cov_report/index.html &

clean: clean_simulate clean_compile

clean_simulate:
	rm -rf *_test*

clean_compile:
	rm -rf libs/ *_compile.log transcript *.log design.bin modelsim.ini
	rm -rf merged_coverage.ucdb merged_cov_html_report

##
## For Regression and coverage merge
##
regression: clean_simulate compile
	# Run simualtion - regression 
	python regression_handling.py $(testlist_name)
	#	# Get the tests from regression list
	#	grep "_test" ../../src/hvl_top/testlists/axi4_simple_fd_regression.list | grep -v "\#" > reg_list
	#	make simulate TEST=value #Get the name from regression list
	#	Merge coverage
		
# For merge to happen, the coverage names for each TEST must be different
#
merge_cov_report:
	rm -rf merged_coverage.ucdb merged_cov_html_report
	# Merging all the coverage
	vcover merge merged_coverage.ucdb -64 */*.ucdb  
	#vcover merge mem_cover mem_cov1 mem_cov2 mem_cov3 mem_cov4 mem_cov5 mem_cov6 mem_cov7 mem_cov8
	vcover report -html merged_coverage.ucdb -htmldir ./merged_cov_html_report -details

	echo "";
	echo "-----------------------------------------------------------------";
	echo "Coverage report: firefox merged_cov_html_report/index.html &"
	echo "-----------------------------------------------------------------";
	echo "";

compile_war_err:
	echo "";
	echo "-----------------------------------------------------------------";
	echo "------------------- Compilation Report --------------------------";
	echo "";
	grep "^** " axi4_compile.log;
	echo "";
	grep "^Error" axi4_compile.log;
	echo "";
	echo "Log file path: axi4_compile.log"
	echo "";
	echo "-----------------------------------------------------------------";
	echo "-----------------------------------------------------------------";
	echo "";

simulate_war_err:
	echo "";
	echo "-----------------------------------------------------------------";
	echo "-------------------- Simulation Report --------------------------";
	echo "";
	echo "Simulator Errors";
	grep "Error" $(TEST_FOLDER)/$(TEST).log;
	echo "";
	echo "UVM Fatal";
	grep "UVM_FATAL" $(TEST_FOLDER)/$(TEST).log;
	echo "";
	echo "UVM Errors";
	grep "UVM_ERROR" $(TEST_FOLDER)/$(TEST).log;
	echo "";
	echo "UVM Warnings";
	grep "UVM_WARNING" $(TEST_FOLDER)/$(TEST).log;
	echo "";
	echo "Testname: $(TEST)"
	echo "";
	echo "Log file path: $(TEST_FOLDER)/$(TEST).log"
	echo "";
	echo "Coverage report: firefox $(TEST_FOLDER)/html_cov_report/index.html &"
	echo "";
	echo "-----------------------------------------------------------------";
	echo "-----------------------------------------------------------------";
	echo "";
