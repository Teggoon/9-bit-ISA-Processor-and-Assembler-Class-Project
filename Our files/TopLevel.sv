// Create Date:    2018.04.05
// Design Name:    BasicProcessor
// Module Name:    TopLevel
// CSE141L
// partial only
module TopLevel(		   // you will have the same 3 ports
    input        Reset,	   // init/reset, active high
			     Start,    // start next program
	             Clk,	   // clock -- posedge used inside design
    output logic Ack	   // done flag from DUT
    );

wire [ 9:0] PgmCtr,        // program counter
			PCTarg;
wire [ 8:0] Instruction;   // our 9-bit opcode
wire [ 3:0] RegReadAddrA, RegReadAddrB, RegWriteAddr;  // ADDED reg_file outputs
wire [ 7:0] RegReadOutA, RegReadOutB;  // RENAMED (original = ReadA, ReadB) reg_file outputs
wire [ 7:0] ALUInA, ALUInB, 	   // ALU operand inputs
            ALU_out;       // ALU result
wire [ 7:0] RegWriteValue, // data in to reg file
            MemWriteValue, // data in to data_memory
	   	    MemReadValue;  // data out from data_memory
wire        MemWrite,	   // data_memory write enable
            RegWrEn,	   // reg_file write enable
            LoadInst, //ADDED
            ConditionalJump,	       // Whether we're supposed to jump conditionally
            BranchAbsOrRel,	// to program counter: relative or absolute
            MiddleFlag1,  // ADDED Used for rc_transfer, arithmetic & logical operations, mem_op
            MiddleFlag2;  // ADDED Used for rc_transfer only
wire [ 1:0] ConstantControl,  // ADDED Used for rc_custom
            BranchConditions; // ADDED 2 bits that are used to check the conditions in which we branch
logic[15:0] CycleCt;	   // standalone; NOT PC!

logic       ActuallyJump, // Whether we're gonna jump given the conditions
            Zero,         // ALU flag 1
            Negative;      // ALU flag 2


// Combinational Logic setting ActuallyJump's value
always_comb begin
 ActuallyJump = 1'b0;
 if (ConditionalJump) begin
    case (BranchConditions)
      'b00 : begin                  // Greater Than: Operand A > Operand B
        ActuallyJump = !Zero && !Negative;
      end
      'b01: begin                  // Less Than: Operand A < Operand B
        ActuallyJump = !Zero && Negative;
      end
      'b10: begin                  // Equal to: Operand A == Operand B
        ActuallyJump = Zero;
      end
      'b11: begin                  // Unconditional Jump
        ActuallyJump = 1;
      end
    endcase
  end
end

assign BranchAbsOrRel = ConditionalJump && MiddleFlag1;


// Fetch = Program Counter + Instruction ROM
// Program Counter
  InstFetch IF1 (
	.Reset       (Reset   ) ,
	.Start       (Start   ) ,  // SystemVerilg shorthand for .halt(halt),
	.Clk         (Clk     ) ,  // (Clk) is required in Verilog, optional in SystemVerilog
	.Jump   (ActuallyJump    ) ,  // Jump enable
	.BranchAbsOrRel (BranchAbsOrRel) ,  // branch relatively or absolutely
  .Target      (PCTarg  ) ,
	.ProgCtr     (PgmCtr  )	   // program count = index to instruction memory
	);

// Control decoder
  Ctrl Ctrl1 (
	.Instruction  (Instruction), // from instr_ROM
	.ConditionalJump  (ConditionalJump),		     // to PC
	.BranchAbsOrRel (BranchAbsOrRel),		 // to PC
  .RegWrEn      (RegWrEn),
  .MemWrEn      (MemWrite),
  .LoadInst     (LoadInst),
  .PCTarg       (PCTarg),
  .RegReadAddrA (RegReadAddrA),
  .RegReadAddrB (RegReadAddrB),
  .RegWriteAddr (RegWriteAddr),
  .MiddleFlag1   (MiddleFlag1),
  .MiddleFlag2   (MiddleFlag2),
  .ConstantControl  (ConstantControl),
  .BranchConditions (BranchConditions)
  );
// instruction ROM
  InstROM #(.W(9)) IR1(
	.InstAddress   (PgmCtr),
	.InstOut       (Instruction)
	);

  assign LoadInst = Instruction[8:6]==3'b110;  // calls out load specially
  assign Ack = &Instruction;
// reg file
	RegFile #(.W(8),.D(3)) RF1 (
		.Clk    				  ,
		.WriteEn   (RegWrEn)    ,
		.RaddrA    (RegReadAddrA),         //concatenate with 0 to give us 4 bits
		.RaddrB    (RegReadAddrB),
		.Waddr     (RegWriteAddr),
		.DataIn    (RegWriteValue) ,
		.DataOutA  (RegReadOutA        ) ,
		.DataOutB  (RegReadOutB		 )
	);
// one pointer, two adjacent read accesses: (optional approach)
//	.raddrA ({Instruction[5:3],1'b0});
//	.raddrB ({Instruction[5:3],1'b1});

    assign ALUInA = RegReadOutA;						          // TODO: not simple as that
	assign ALUInB = RegReadOutB;
	assign RegWriteValue = LoadInst? MemReadValue : ALU_out;  // 2:1 switch into reg_file
    ALU ALU1  (
	  .InputA  (ALUInA),
	  .InputB  (ALUInB),
	  .OP      (Instruction[8:5]),
    .ControlFlags  (ConstantControl),
	  .Out     (ALU_out),//regWriteValue),
	  .Zero    (Zero),
    .Negative (Negative)
	  );

	DataMem DM1(
		.DataAddress  (RegReadOutA)    ,
		.WriteEn      (MemWrite),
		.DataIn       (MemWriteValue),
		.DataOut      (MemReadValue)  ,
		.Clk 		  		     ,
		.Reset		  (Reset)
	);

// count number of instructions executed
always_ff @(posedge Clk)
  if (Start == 1)	   // if(start)
  	CycleCt <= 0;
  else if(Ack == 0)   // if(!halt)
  	CycleCt <= CycleCt+16'b1;

endmodule
