/* This module reads from RAM-memory-stored note data and writes 1/8s of each note to the CODEC
 * This ASMD works in conjunction with a ROM select module and address counter to sequentially write 
 * the correct notes to the CODEC
 * Inputs:
 *   clk    - should be connected to a 50MHz clock
 *   reset  - resets the module and starts over the drawing process
 *	  read_ready, write_ready - CODEC signals
 *   full - signal that user note loading is complete
 *
 * Outputs:
 *   RAM_read_addr - address to be accessed in note_RAM
 *   write_note - signal to be connected to CODEC's 'write'
 *	  audio_start - signal for top-level system to know when audio writing is occurring
 *   done        - signal that all audio writing is complete
 *
 */
module audio_output(clk, reset, read_ready, write_ready, full,
						RAM_read_addr, write_note, audio_start, done);
	input logic clk, reset, read_ready, write_ready, full;
	output logic write_note;
	output logic audio_start, done;
	output logic [6:0] RAM_read_addr;
	
	//define status and control signals
	//status signals
	logic start_audio, codec_ready, num_writes_eq_max, RAM_read_eq_max;
	//control signals
	logic load_regs, update_note, incr_num_writes, set_write_note,
					 reset_write_note, audio_done, incr_RAM_addr;
	
	//instantiate controller and datapath
	audio_output_controller ao_c (.*);
	audio_output_datapath ao_d (.*);
	
endmodule  // audio_output