//this is the datapath for the audio output module. it takes in control signals
//from the controller and updates status signals accordingly

module audio_output_datapath (clk, reset, start_audio, codec_ready, num_writes_eq_max, RAM_read_eq_max,
										load_regs, update_note, incr_num_writes, set_write_note,incr_RAM_addr,
										reset_write_note, audio_done, read_ready, write_ready, full, RAM_read_addr, write_note, audio_start, done);
	
	
	//port definitions
	input logic clk, reset;
	//SYSTEM inputs/outputs
	input logic read_ready, write_ready, full;
	output logic [6:0] RAM_read_addr; //addr with which to access note ID
	output logic write_note,audio_start, done;
	logic [12:0] num_writes;
	//internal ASMD signals
	//status signals
	output logic start_audio, codec_ready, num_writes_eq_max, RAM_read_eq_max; //status signals
	//control signals
	input logic load_regs, update_note, incr_num_writes, set_write_note,
										reset_write_note, audio_done, incr_RAM_addr; //control signals
	
	//parameters
	parameter [2:0] A_ID = 3'b001;
	parameter [2:0] B_ID = 3'b010;
	parameter [2:0] C_ID = 3'b011;
	parameter [2:0] D_ID = 3'b100;
	parameter [2:0] E_ID = 3'b101;
	parameter [2:0] F_ID = 3'b110;
	parameter [2:0] G_ID = 3'b111;
	parameter [6:0] MAX_RAM_ADDR = 7'b1110111;
	parameter [12:0] MAX_NUM_WRITES = 13'b1100001101010;
	
	// datapath logic
	
	always_ff @(posedge clk) begin
		if (load_regs) begin
			done <= 0;
			audio_start <= 1;
			RAM_read_addr <= 0;
			num_writes <= 0;
		end
		if (update_note) begin
			num_writes <= 0;
			write_note <= 0;
		end
		if (incr_num_writes) begin
			num_writes <= num_writes + 1'b1;
		end
		if (set_write_note) begin
			write_note <= 1;
		end
		if (reset_write_note) begin
			write_note <= 0;
		end
		if (audio_done) begin
			done <= 1;
			audio_start <= 0;
		end
		if (incr_RAM_addr) begin
			RAM_read_addr <= RAM_read_addr + 1'b1;
		end
	end //always_ff
	
	//assign ouputs
	//start_audio, codec_ready, num_writes_eq_max, RAM_read_eq_max
	assign start_audio = full;
	assign codec_ready = write_ready && read_ready;
	assign num_writes_eq_max = num_writes == MAX_NUM_WRITES;
	assign RAM_read_eq_max = RAM_read_addr == MAX_RAM_ADDR;
	


endmodule // audio_output_datapath