//This file defines the parameters used in the alu
// CSE141L
//	Rev. 2020.5.27
// import package into each module that needs it
//   packages very useful for declaring global variables
package definitions;
    
// Instruction map
	const logic [3:0]kRC_ADD  	= 4'b0000;
	const logic [3:0]kRC_SUB  	= 4'b0001;
	const logic [3:0]kRC_LSL  	= 4'b0010;
	const logic [3:0]kRC_LSR  	= 4'b0011;
	const logic [3:0]kRC_TRANSFER  	= 4'b0100;
	const logic [3:0]kRC_CUSTOM  	= 4'b0101;
	const logic [3:0]kREG_COPY  	= 4'b0110;
	const logic [3:0]kADD	  	= 4'b0111;
	const logic [3:0]kSUB	  	= 4'b1000;
	const logic [3:0]kXOR	  	= 4'b1001;
	const logic [3:0]kAND	  	= 4'b1010;
	const logic [3:0]kLSL	  	= 4'b1011;
	const logic [3:0]kLSR	  	= 4'b1100;
	const logic [3:0]kMEM_OP  	= 4'b1101;
	const logic [3:0]kCMP	  	= 4'b1110;
	const logic [3:0]kBRANCH  	= 4'b1111;
// enum names will appear in timing diagram
	typedef enum logic[3:0] {
        RC_ADD, RC_SUB, RC_LSL, RC_LSR, 
	RC_TRANSFER, RC_CUSTOM, REG_COPY, ADD, 
	SUB, XOR, AND, LSL, 
	LSR, MEM_OP, CMP, BRANCH } op_mne;
	// note: kADD is of type logic[3:0] (4-bit binary)
//   ADD is of type enum -- equiv., but watch casting
//   see ALU.sv for how to handle this   
endpackage // definitions
