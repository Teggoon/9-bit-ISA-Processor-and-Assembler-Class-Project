// CSE141L
import definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[ 8:0] Instruction,	   // machine code
  output logic Jump     ,
          BranchEn ,
			   RegWrEn  ,	   // write to reg_file (common)
			   MemWrEn  ,	   // write to mem (store only)
			   LoadInst	,	   // mem or ALU to reg_file ?
        RegReadAddrA, // ADDED register read address
        RegReadAddrB,
        RegWriteAddr,
			   Ack,		       // "done w/ program"
  output logic [ 9:0] PCTarg
  );

	// mem_write is true on mem_op with flag 1
	assign MemWrEn = Instruction[8:4]==5'b11011;


	// Operations that write to register:
	// rc_add
	// rc_sub
	// rc_lsl
	// rc_lsr
	// rc_transfer
	// rc_custom
	// reg_copy
	// add
	// sub
	// XOR
	// AND
	// LSL
	// LSR
	// MEM_OP, flag 0

	// Operations that don't write to register:
	// CMP				1110
	// Branch			1111
	// MEM_OP, flag 1		11011
	assign RegWrEn = Instruction[8:6] != 3'b111 && Instruction[8:4] != 5'b11011;

	assign LoadInst = Instruction[8:4]==5'b11010;  // calls out load specially
// reserve instruction = 9'b111111111; for Ack

// jump on right shift that generates a zero
// equiv to simply: assign Jump = Instrucxtion[2:0] == kRSH;
always_comb
  if(Instruction[2:0] ==  kRSH)
    Jump = 1;
  else
    Jump = 0;

// branch every time instruction = 9'b?????1111;
assign BranchEn = &Instruction[3:0];

// route data memory --> reg_file for loads
//   whenever instruction = 9'b110??????;
assign PCTarg  = Instruction[3:2];

assign Ack = &Instruction;

endmodule
