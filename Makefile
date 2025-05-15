# Makefile for QuestaSim Simulation

# Variables
VLOG         = vlog
VSIM         = vsim
WORK         = work
TOP_MODULE   = topmodule_tb
SOURCES      = alu.sv display_driver.sv memory.sv state_based_controller.sv topmodule.sv topmodule_tb.sv
GUI          = -gui
WAVE_OPTIONS = -do "add wave -r /*; run -all"

# Targets
all: compile simulate

compile:
	$(VLOG) -work $(WORK) -sv $(SOURCES)

simulate:
	$(VSIM) $(GUI) -voptargs="+acc" $(WORK).$(TOP_MODULE) $(WAVE_OPTIONS)

clean:
	rmdir /S /Q work
	del /Q -rf transcript vsim.wlf

.PHONY: all compile simulate clean