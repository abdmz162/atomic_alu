# Makefile for QuestaSim

# Declare phony targets
.PHONY: all compile simulate gui display_gui clean run check_hex

# Variables
VLOG = vlog
VSIM = vsim
WORK = work
TB = topmodule_tb           # our main testbench
DISPLAY_TB = tb_seven_seg_display_driver  # display_driver testbench
SRC = alu.sv controller.sv display_driver.sv memory.sv state_based_controller.sv topmodule.sv
HEX_FILE = register_init.hex
WAVEFORM_DO = wave.do      # Waveform configuration file

# Default target (compile + simulate)
all: check_hex compile simulate

# Check if hex file exists
check_hex:
    @if not exist $(HEX_FILE) ( \
        echo Error: $(HEX_FILE) not found && \
        exit 1 \
    )

# Create work library and compile
compile: work $(SRC)
    $(VLOG) -sv $(SRC)

# Create work library
work:
    if exist $(WORK) rd /s /q $(WORK)
    vlib work
    vmap work work

# Run simulation in console mode
simulate:
    $(VSIM) -c -do "run -all; quit" $(TB)

# Run simulation with GUI and waveform viewing
gui: compile
    $(VSIM) -gui -do $(WAVEFORM_DO) $(TB)

# Run display driver testbench with GUI
display_gui: compile
    $(VSIM) -gui -do "add wave -r /*; run -all" $(DISPLAY_TB)

# Create waveform configuration file
wave.do:
    echo add wave -r /* > $(WAVEFORM_DO)
    echo run -all >> $(WAVEFORM_DO)

# Clean generated files
clean:
    if exist $(WORK) rd /s /q $(WORK)
    if exist transcript del transcript
    if exist vsim.wlf del vsim.wlf
    if exist $(WAVEFORM_DO) del $(WAVEFORM_DO)

# Shortcut for quick simulation
run: compile simulate