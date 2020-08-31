// Create Date:    2018.10.15
// Module Name:    ALU
// Project Name:   CSE141L
//
// Revision 2018.01.27
// Additional Comments:
//   combinational (unclocked) ALU
import definitions::*;			         // includes package "definitions"
module ALU(
  input        [7:0] InputA,             // data inputs
                     InputB,
  input        [3:0] OP,		         // ALU opcode, part of microcode
  input         [2:0] ControlFlags,  // ALU code for choosing a constant for rc_custom
  output logic [7:0] Out,		         // or:  output reg [7:0] OUT,
  output logic Zero,                // ALU Flag 1
               Negative            // ALU Flag 2
    );
  logic [6:0] input_state;
  logic [6:0] input_tap;

  op_mne op_mnemonic;			         // type enum: used for convenient waveform viewing

 // Our convention: if relevant, InputA is interpreted as Rd/Rm
  always_comb begin
    Out = 0;                             // No Op = default
    input_state = 0;
    input_tap = 0;
    Negative = 1'b0;
    Zero = 1'b0;
    case(OP)
      kRC_ADD : begin
      Out = InputA + InputB;
      end
      kRC_SUB : Out = InputA - InputB;
      kLFSR : begin
        input_state = InputB[6:0];
        input_tap = InputA[6:0];
        Out = {input_state[5:0], ^ (input_tap & input_state)};
      end
      kRC_LOAD : Out = InputB;
      kRC_TRANSFER : Out = InputB;
      kPARITY_BIT : begin
        Out[7] = InputB[6] ^ InputB[5] ^ InputB[4] ^ InputB[3] ^ InputB[2] ^ InputB[1] ^ InputB[0];
        Out[6:0] = InputB[6:0];
        end
      kREG_COPY : Out = InputB;
      kADD : Out = InputA + InputB;      // add
      kSUB : Out = InputA - InputB;       // subtract
   	  kXOR : Out = InputA ^ InputB;      // exclusive OR
      kAND : begin
        Out = InputA & InputB;      // bitwise AND
      end
      kLSL : Out = InputA << InputB;  	     // shift left
      kLSR : Out = InputA >> InputB;
      kCMP :  begin
        $display("CMP: Comparing %d and %d", InputB, InputA);
        Out =  InputA - InputB;
        if (Out == 'b0) begin Zero = 1'b1; end
        if (Out[7] == 1'b1) begin Negative = 1'b1; end
      end
      kBRANCH : Out = 1'b1;          // TODO
    endcase
  end


  always_comb
    op_mnemonic = op_mne'(OP);			 // displays operation name in waveform viewer

endmodule
