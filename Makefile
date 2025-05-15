# Makefile for QuestaSim Simulation with Full Hierarchy

# Variables
VLOG         = vlog
VSIM         = vsim
WORK         = work
TOP_MODULE   = topmodule_tb
SOURCES      = alu.sv display_driver.sv memory.sv state_based_controller.sv topmodule.sv topmodule_tb.sv
GUI          = -gui
WAVE_OPTIONS = -do "add wave -r /dut/*; add wave -r /dut/ctrl/*; add wave -r /dut/top_alu/*; add wave -r /dut/display/*; add wave -r /dut/alu_a_register/*; add wave -r /dut/alu_b_register/*; run -all"

# Targets
all: compile simulate

compile:
	$(VLOG) -work $(WORK) -sv $(SOURCES)

simulate:
	$(VSIM) $(GUI) $(WORK).$(TOP_MODULE) $(WAVE_OPTIONS)

clean:
	rm -rf $(WORK) transcript vsim.wlf

.PHONY: all compile simulate clean