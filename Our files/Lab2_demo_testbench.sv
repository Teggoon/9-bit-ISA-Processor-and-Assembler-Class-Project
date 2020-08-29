// Create Date:   2017.01.25
// Design Name:   TopLevel Test Bench
// Module Name:   TopLevel_tb.v
//  CSE141L
// This is NOT synthesizable; use for logic simulation only
// Verilog Test Fixture created for module: TopLevel

module Lab2_demo_testbench;	     // Lab 17

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

  #20ns

  $display("\nThe following is a demo of our ALU's operations:");
  $display("1. Addition");
  $display("2. Subtraction");
  $display("3. Parity_bit");
  $display("4. LFSR");
  $display("5. Logical shift left");
  $display("6. Bitwise XOR");
  $display("7. Bitwise AND\n\n");

  $display("We begin with addition and subtraction.\n");

  $display("Loaded #2 into R15, which we call RC, our designated register that acts as an accumulator to create large numbers quickly.");
  $display("Confirm RC (R15) value: %d", DUT.RF1.Registers[15]);

  #10ns

  $display("\n");
  $display("Instruction: RC_ADD 12 // add 12 to RC, so RC should now be 14");
  $display("Confirm RC (R15) value: %d", DUT.RF1.Registers[15]);

  #10ns

  $display("\n");
  $display("Instruction: RC_SUB 3 // sub 3 from RC, so RC should now be 11");
  $display("Confirm RC (R15) value: %d", DUT.RF1.Registers[15]);

  #10ns

  $display("\n");
  $display("We now test Parity_bit, which overwrites the first bit with the parity_bit of the register's original value");
  $display("Instruction: Parity_bit R15. R15 was 0b00001011 before, so the leading parity_bit should be 1, and the output 10001011.");
  $display("Confirm RC (R15) value: %b", DUT.RF1.Registers[15]);



  $display("\n");
  $display("LFSR test. We first move our init state from RC to another register, since RC is needed to compute which tap we're using. We'll use R6");
  $display("Instruction: RC_STORE R6");
  #10ns
  $display("Confirm R6 value: %b", DUT.RF1.Registers[6]);
  $display("We also confirm that the 9 maximal length taps had been preloaded as constants into the taps already:");
  for(int j=0; j<9; j++)
    $display("Tap %d value: %b", j, DUT.taps[j]);
  #10ns
  $display("We'll use tap[0], so we set RC to be 0");
  $display("Instruction: RC_LOADI #0");
  $display("Confirm RC (R15) value: %b", DUT.RF1.Registers[15]);

  $display("Next we advance LFSR several times on R6 with the instruction LFSR R6:");
  #10ns
  $display("R6[6:0]: %b", DUT.RF1.Registers[6][6:0]);
  #10ns
  $display("R6[6:0]: %b", DUT.RF1.Registers[6][6:0]);
  #10ns
  $display("R6[6:0]: %b", DUT.RF1.Registers[6][6:0]);
  #10ns
  $display("R6[6:0]: %b", DUT.RF1.Registers[6][6:0]);
  #10ns
  $display("R6[6:0]: %b", DUT.RF1.Registers[6][6:0]);
  #10ns
  $display("R6[6:0]: %b", DUT.RF1.Registers[6][6:0]);

  $display("Notice how the rightmost bit is always the XOR of the leftmost 2 bits of the previous value, corresponding with our tap.");
  $display("That is our LFSR operation");

  $display("\n\nLogical shift left test:");
  $display("Our logical shift left only operates on r0-r3, so we'll copy R6 into R2.");
  #10ns
  #10ns
  $display("Confirm R2 value: %b", DUT.RF1.Registers[2]);

  $display("We'll shift R2 left by 2 bits");
  $display("Instruction: LSLI 2, r2");
  #10ns
  $display("Confirm R2 value: %b", DUT.RF1.Registers[2]);

  $display("\n");
  $display("XOR test: we will XOR R2 with 11111111, essentially flipping all the bits");
  #30ns
  $display("R2 value before instruction: %b", DUT.RF1.Registers[2]);
  #10ns
  $display("R2 value after instruction:  %b", DUT.RF1.Registers[2]);


  $display("\n");
  $display("AND test: we'll AND R2 with  00001100");
  $display("R2 value before instruction: %b", DUT.RF1.Registers[2]);
  #20ns
  #10ns
  $display("R2 value after instruction:  %b", DUT.RF1.Registers[2]);

  $display("\n\nAs you can see, everything works! I hope you are satisfied with our presentation.\n\n");

  #10ns
  $stop;
end

always begin   // clock period = 10 Verilog time units
  #5ns  Clk = 'b1;
  #5ns  Clk = 'b0;
end

endmodule
