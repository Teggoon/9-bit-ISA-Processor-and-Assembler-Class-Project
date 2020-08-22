// Create Date:   2017.01.25
// Design Name:   TopLevel Test Bench
// Module Name:   TopLevel_tb.v
//  CSE141L
// This is NOT synthesizable; use for logic simulation only
// Verilog Test Fixture created for module: TopLevel

module Module_tb_ALU;	     // Lab 17

/*

module ALU(
  input        [7:0] InputA,             // data inputs
                     InputB,
  input        [3:0] OP,		         // ALU opcode, part of microcode
  input         [2:0] ControlFlags,  // ALU code for choosing a constant for rc_custom
  output logic [7:0] Out,		         // or:  output reg [7:0] OUT,
  output logic Zero,                // ALU Flag 1
               Negative            // ALU Flag 2
    );
*/

// To DUT Inputs
  logic [7:0] tb_InputA,             // data inputs
              tb_InputB;
  logic [3:0] tb_OP;		         // ALU opcode, part of microcode
  logic [2:0] tb_ControlFlags;  // ALU code for choosing a constant for rc_custom
  logic [7:0] tb_ALU_out;		         // or:  output reg [7:0] OUT,
  logic [7:0] tb_ALU_out_desired;		         // or:  output reg [7:0] OUT,
  logic       tb_Zero,                // ALU Flag 1
              tb_Negative;            // ALU Flag 2

// From DUT Outputs

// Instantiate the Device Under Test (DUT)
  ALU DUT (
  .InputA  (tb_InputA),
  .InputB  (tb_InputB),
  .OP      (tb_OP),
  .ControlFlags  (tb_ControlFlags),
  .Out     (tb_ALU_out),
  .Zero    (tb_Zero),
  .Negative (tb_Negative)
	);

initial begin


  // ZERO FLAG test
  #10ns
  tb_InputA = 8'b0;
  tb_InputB = 8'b0;
  tb_OP = 4'b0111;
  #10ns
  $display("instruction = %b", tb_OP);
  $display("inputA = %b, inputB = %b", tb_InputA, tb_InputB);
  $display("Output = %b", tb_ALU_out);
  tb_ALU_out_desired =  tb_InputA + tb_InputB;
  $display("Output desired = %b", tb_ALU_out_desired);
  $display("Output Zero Flag = %b", tb_Zero);
  $display("\n\n\n");

  // ADDITION test
  #10ns
  tb_InputA = 8'b11011;
  tb_InputB = 8'b01011;
  tb_OP = 4'b0111;
  #10ns
  $display("instruction = %b", tb_OP);
  $display("inputA = %b, inputB = %b", tb_InputA, tb_InputB);
  $display("Output = %b", tb_ALU_out);
  tb_ALU_out_desired =  tb_InputA + tb_InputB;
  $display("Output desired = %b", tb_ALU_out_desired);
  $display("\n\n\n");

  // Subtraction & Negative test
  #10ns
  tb_InputA = 8'b1;
  tb_InputB = 8'b11;
  tb_OP = 4'b1000;
  #10ns
  $display("instruction = %b", tb_OP);
  $display("inputA = %b, inputB = %b", tb_InputA, tb_InputB);
  $display("Output = %b", tb_ALU_out);
  tb_ALU_out_desired =  tb_InputA - tb_InputB;
  $display("Output desired = %b", tb_ALU_out_desired);
  $display("Output Neg Flag = %b", tb_Negative);
  $display("\n\n\n");


  // Shift test
  #10ns
  tb_InputA = 8'b11111000;
  tb_InputB = 8'b11;
  tb_OP = 4'b1100;
  #10ns
  $display("instruction = %b", tb_OP);
  $display("inputA = %b, inputB = %b", tb_InputA, tb_InputB);
  $display("Output = %b", tb_ALU_out);
  $display("\n\n\n");

  #10ns $stop;

end

endmodule
