// CSE141L
import definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[ 8:0] Instruction,	   // machine code
  output logic ConditionalJump     ,     // moves the program counter: ConditionalJump or increment normally
          BranchAbsOrRel ,    // ConditionalJump relatively or absolutely
			   RegWrEn  ,	   // write to reg_file (common)
			   MemWrEn  ,	   // write to mem (store only)
			   LoadInst	,	   // mem or ALU to reg_file ?
        MiddleFlag1, // ADDED
        MiddleFlag2, // ADDED
			   Ack,		       // "done w/ program"
  output logic [ 2:0] ConstantControl, // ADDED
  output logic [3:0] RegReadAddrA, // ADDED register read address
                    RegReadAddrB, // ADDED register read address
                    RegWriteAddr, // ADDED
  output logic [ 9:0] PCTarg,
  output logic [1:0] BranchConditions
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

  always_comb begin
    RegReadAddrA = Instruction[1:0];
    RegReadAddrB = Instruction[3:2];
    MiddleFlag1 = Instruction[4];
    MiddleFlag2 = Instruction[5];
    ConstantControl = Instruction[4:2];
    RegWriteAddr = Instruction[1:0];
    if (Instruction[8:5] == 4'b0000 ||    // rc_add
        Instruction[8:5] == 4'b0001 ||    // rc_sub
        Instruction[8:5] == 4'b0010 ||    // rc_lsl
        Instruction[8:5] == 4'b0011 ||    // rc_lsr
        Instruction[8:4] == 5'b01000       // rc_transfer, load into
        ) begin
          RegWriteAddr = 4'b1111;  // R16 is RC
        end
    if (Instruction[8:4] == 5'b01001) begin // rc_transfer, store out of
      RegWriteAddr = Instruction[2:0];    // 3-bit, 8 potential registers
    end

    if (Instruction[8:5] == 4'b0110) begin  // reg_copy
    if (Instruction[4] == 1'b0) begin       // 2-bit addr to 2-bit addr reg_copy
      RegReadAddrA = Instruction[1:0];
      RegReadAddrB = Instruction[3:2];
    end
    else begin                              // 4-bit reg_copy using rc
      RegWriteAddr = Instruction[3:0];
      RegReadAddrA = 4'b1111;
      RegReadAddrB = 4'b1111;
    end
    end
  end

// ConditionalJump on right shift that generates a zero
// equiv to simply: assign ConditionalJump = Instrucxtion[2:0] == kRSH;

assign BranchConditions = Instruction[3:2];

// branch every time instruction = 9'b?????1111;
assign ConditionalJump = Instruction[8:5] == 4'b1111;
assign BranchAbsOrRel = Instruction[4]; // 0 = absolute, 1 = relative

// route data memory --> reg_file for loads
//   whenever instruction = 9'b110??????;
assign PCTarg  = Instruction[3:2];

assign Ack = &Instruction;

endmodule
