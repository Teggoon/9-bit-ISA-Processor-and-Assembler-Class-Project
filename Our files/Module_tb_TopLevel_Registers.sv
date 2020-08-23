// Create Date:   2017.01.25
// Design Name:   TopLevel Test Bench
// Module Name:   TopLevel_tb.v
//  CSE141L
// This is NOT synthesizable; use for logic simulation only
// Verilog Test Fixture created for module: TopLevel

module Module_tb_TopLevel_Registers;	     // Lab 17

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

// Initialize DUT's register file
  for(int j=0; j<16; j++)
    DUT.RF1.Registers[j] = 8'b1;    // default -- clear it

  #10ns Req = 0;



  #150ns

  for(int j=0; j<16; j++)
    $display("R %d value: %b", j, DUT.RF1.Registers[j]);
  #10ns

  $stop;
end

always begin   // clock period = 10 Verilog time units
  #5ns  Clk = 'b1;
  #5ns  Clk = 'b0;
end

endmodule
