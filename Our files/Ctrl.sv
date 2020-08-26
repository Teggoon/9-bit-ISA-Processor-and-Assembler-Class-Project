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
  output logic [1:0] BranchConditions
  );

	// mem_write is true on mem_op with flag 1
	assign MemWrEn = Instruction[8:4]==5'b11011;


	// Operations that write to register:
	// rc_add
	// rc_sub
	// rc_load
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
  // LFSR, flag 0
	assign RegWrEn = Instruction[8:6] != 3'b111 && Instruction[8:4] != 5'b11011 && Instruction[8:4] != 5'b00100;

	assign LoadInst = Instruction[8:4]==5'b11010;  // calls out load specially
// reserve instruction = 9'b111111111; for Ack

  always_comb begin
    RegReadAddrA = Instruction[1:0];
    RegReadAddrB = Instruction[3:2];
    MiddleFlag1 = Instruction[4];
    MiddleFlag2 = Instruction[5];
    ConstantControl = Instruction[4:2];
    RegWriteAddr = Instruction[1:0];


    if (Instruction[8:7] == 2'b00) begin    // rc add, sub, shift, load
        RegWriteAddr = 4'b1111;  // R15 is RC
        RegReadAddrA = 4'b1111;
    end


    if (Instruction[8:5] == 4'b0100) begin // rc_transfer, store out of
      if (Instruction[4] == 1'b0) begin     // load into rc
        RegWriteAddr = 4'b1111;  // Destination is RC
        RegReadAddrB = Instruction[3:0];  // 4-bit, 16 potential registers
      end
      else begin                            // 01001 export out of rc into a reg
        RegReadAddrB = 4'b1111;
        RegWriteAddr = Instruction[3:0];    // 4-bit, 16 potential registers
      end
    end

    if (Instruction[8:5] == 4'b0010) begin  // LFSR
      if (Instruction[4] == 1'b0) begin     // Load in a tap
        RegReadAddrA = 4'b1111;
        RegReadAddrB = 4'b1111;
      end
      else begin                            // advance the state
        RegReadAddrA = 4'b1111;
        RegReadAddrB = Instruction[3:0];
        RegWriteAddr = Instruction[3:0];
      end
    end

    if (Instruction[8:5] == 4'b0101) begin  // Parity_bit
        RegReadAddrA = Instruction[3:0];
        RegReadAddrB = Instruction[3:0];    // Get Rm addr
        RegWriteAddr = Instruction[3:0];    // Get RD addr
    end

    if (Instruction[8:5] == 4'b1111) begin  // Conditional Branching
        RegReadAddrA = Instruction[1:0] + 4'b1011;
    end


    if (Instruction[8:5] == 4'b0110) begin  // reg_copy
    if (Instruction[4] == 1'b0) begin       // 2-bit addr to 2-bit addr reg_copy
      RegWriteAddr = Instruction[1:0];
      RegReadAddrB = Instruction[3:2];
    end
    else begin                              // 4-bit reg_copy using rc. RC holds Rd addr, operand = Rm addr
      RegReadAddrA = 4'b1111;
      RegReadAddrB = Instruction[3:0];    // Get Rm addr
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

assign Ack = &Instruction;

endmodule
