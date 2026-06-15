# Create work library
vlib work
# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./note_input_tb.sv"
vlog "./note_input_datapath.sv"
vlog "./note_input_controller.sv"
vlog "./note_input.sv"
vlog "./noise_gen.sv"
vlog "./DE1_SoC.sv"
vlog "./DE1_SoC_tb.sv"
vlog "./clock_generator.v"
vlog "./audio_codec.v"
vlog "./audio_and_video_config.v"
vlog "./clock_divider_8.sv"
vlog "./clock_divider_8_tb.sv"
vlog "./n8_driver.sv"
vlog "./serial_driver.sv"
vlog "./note_ram120x3.v"
vlog "./note_ROM_select.sv"
vlog "./ROM_addr_counter.sv"
vlog "./A4_ROM.v"
vlog "./B4_ROM.v"
vlog "./C4_ROM.v"
vlog "./D4_ROM.v"
vlog "./E4_ROM.v"
vlog "./F4_ROM.v"
vlog "./G4_ROM.v"
vlog "./FIR_filter.sv"
vlog "./write_pulse.sv"
vlog "./num_writes_counter.sv"
vlog "./get_image.sv"
vlog "./video_driver.sv"
vlog "./background_rom.sv"
vlog "./fifo_ctrl.sv"
vlog "./reg_file.sv"
vlog "./CLOCK25_PLL.v"
vlog "./CLOCK25_PLL_0002.v"
vlog "./Altera_UP_Slow_Clock_Generator.v"
vlog "./Altera_UP_I2C_AV_Auto_Initialize.v"
vlog "./Altera_UP_I2C.v"
vlog "./Altera_UP_Clock_Edge.v"
vlog "./Altera_UP_Audio_In_Deserializer.v"
vlog "./Altera_UP_Audio_Out_Serializer.v"
vlog "./Altera_UP_Audio_Bit_Counter.v"
vlog "./Altera_UP_SYNC_FIFO.v"
vlog "./altera_up_avalon_video_vga_timing.v"
# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work DE1_SoC_tb -Lf altera_mf_ver -Lf altera_ver -Lf altera_lnsim_ver
# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do DE1_SoC_wave.do
# Set the window types
view wave
view structure
view signals
# Run the simulation
run -all
# End
