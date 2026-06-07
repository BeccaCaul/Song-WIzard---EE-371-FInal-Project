//this is the controller for the audio output portion of the Song Wizard
//this system operates on an 50MHz clock
//The controller module includes:
// status signals (inputs): start_audio, load_regs, codec_ready, num_writes_eq_max, RAM_read_eq_max
// control signals (outputs): load_regs, update_note, incr_num_writes, set_write_note, reset_write_note, audio_done
//
module audio_output_controller (clk, reset, start_audio, codec_ready, num_writes_eq_max, RAM_read_eq_max,
										load_regs, update_note, incr_num_writes, set_write_note,
										reset_write_note, audio_done, incr_RAM_addr);

	//port definitions
	input logic clk, reset;
	input logic start_audio, codec_ready, num_writes_eq_max, RAM_read_eq_max; //status signals
	//control signals
	output logic load_regs, update_note, incr_num_writes, set_write_note,
					 reset_write_note, audio_done, incr_RAM_addr;
  
  // define state names and variables
  enum logic [2:0] {S0, S1, S2, S3, S4} ps, ns;

  // next state logic
  always_comb begin
	   case (ps)
			 S0: ns = start_audio ? S1 : S0;
			 S1: ns = S2;
			 S2: ns = codec_ready ? S3 : S2;
			 S3: 
				if (!num_writes_eq_max) begin
					ns = S2;
				end else if (RAM_read_eq_max) begin
					ns = S4;
				end else begin
					ns = S1;
				end
			 S4: ns = S4;
	   endcase
  end //always_comb
  
  	// FSM Outputs - control signals
	assign load_regs = (ps == S0) && start_audio;
	assign update_note = (ps == S1);
	assign incr_num_writes = (ps == S2) && codec_ready;
	assign set_write_note = (ps == S2) && codec_ready;
	//assign incr_note_ROM_addr = (ps == S2) && codec_ready;
	//assign reset_incr = (ps == S3);
	assign reset_write_note = (ps == S3);
	assign audio_done = (ps == S4);
	assign incr_RAM_addr = (ps == S3) && num_writes_eq_max && !RAM_read_eq_max;
	
	// controller logic w/ synchronous reset
	always_ff @(posedge clk)
		if (reset)
			ps <= S0;
		else
			ps <= ns;
  
  
endmodule // audio_output_controller