
/* address counter, iterating through all read addresses in 1 note period: 0-1328*/

module ROM_addr_counter (clk, reset, audio_start, read_ready, write_ready, addr); //addr_counter
  input logic clk;
  input logic reset; 
  input logic read_ready, write_ready, audio_start;
  output logic [15:0] addr;
  logic max;
  
  logic [15:0] count;
  
  assign max = (addr == 16'h052F); //max address before 0 frequency is 1328; should move to 0 at next write
  

  always @(posedge clk or posedge reset) begin //always_ff
    if (reset) begin
      count <= 16'h0000; //reset to 0
    end
	 else if (audio_start) begin
		 if(read_ready && write_ready && ~max) begin
			count <= count + 1'b1;
		 end else if (read_ready && write_ready && max) begin
			count <= 16'h0000;
		 end else begin
			count <= count; //if not ready, stay at current address
		 end
	 end
  end //always_ff
  
  //comb logic
  assign addr = count;
	 
endmodule //ROM_addr_counter