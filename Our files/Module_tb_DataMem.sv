// Create Date:   2017.01.25
// Design Name:   TopLevel Test Bench
// Module Name:   TopLevel_tb.v
//  CSE141L
// This is NOT synthesizable; use for logic simulation only
// Verilog Test Fixture created for module: TopLevel

module Module_tb_DataMem;	     // Lab 17

// To DUT Inputs
  bit  Init = 'b1,
       Req,
       Clk;

// From DUT Outputs
  wire Ack;		   // done flag

// Instantiate the Device Under Test (DUT)
  TopLevel DUT (
    .Reset  (Init)  ,
	.Start  (Req )  ,
	.Clk    (Clk )  ,
	.Ack    (Ack )
	);

initial begin
  #10ns Init = 'b0;
  #10ns Req  = 'b1;

// Initialize DUT's data memory
  #10ns for(int i=0; i<256; i++) begin
    DUT.DM1.Core[i] = 8'h0;	     // clear data_mem
  end

  for(int j=0; j<16; j++)
    DUT.RF1.Registers[j] = 8'b0;    // default -- clear it


// launch prodvgram in DUT
  #10ns Req = 0;



  #150ns
  $display("core[31]: %d",DUT.DM1.Core[31]);

  for(int j=0; j<16; j++) begin
    $display("R %d value: %b", j, DUT.RF1.Registers[j]);
  end


  for(int j=0; j<9; j++)
    $display("Tap %d value: %b", j, DUT.taps[j]);

  #10ns
  $stop;
end

always begin   // clock period = 10 Verilog time units
  #5ns  Clk = 'b1;
  #5ns  Clk = 'b0;
end

endmodule
