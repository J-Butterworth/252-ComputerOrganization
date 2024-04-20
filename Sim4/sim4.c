# include "sim4.h"

// Author: Jason Butterworth.

/**
 * This function will assign the particular bits of each instruction to 
 * their necessary "label". This will be done by shifting and masking 
 * different bit sections of the full instruction.
 * Mask with a binary number which has the same # of 1's as our piece
 * of instruction has bits.
*/
void extract_instructionFields(WORD instruction, InstructionFields *fieldsOut){

    // For each part of instruction, mask the relevant bits.

    // opcode takes up the instruction bits 31-26.
    int opcode = (instruction>>26) & 0x3F;
    fieldsOut -> opcode = opcode;

    // rs takes up the instruction bits 25-21.
    int rs = (instruction>>21) & 0x1F;
    fieldsOut -> rs = rs;

    // rt takes up the instruction bits 20-16.
    int rt = (instruction >> 16) & 0x1F;
    fieldsOut -> rt = rt;

    // rd takes up the instruction bits 15-11.
    // rd only used in R format.
    int rd = (instruction >> 11) & 0x1F;
    fieldsOut -> rd = rd;

    // shamt takes up the instruction bits 10-6.
    // shamt only used in R format.
    int shamt = (instruction >> 6) & 0x1F; //bits 10-6
    fieldsOut -> shamt = shamt;

    // funct takes up the remaining instruction bits. (6-0)
    // funct only used in R format.
    int funct = (instruction) & 0x3F; //bits 5-0
    fieldsOut -> funct = funct;

    // imm16 takes up the last 16 bits of instruction.
    // Only used in I format, replacing rD, shmt, and func.
    int imm16 = (instruction) & 0xFFFF; //bits 15-0
    fieldsOut -> imm16 = imm16;
    
    // Use helper method to create sign extended version of 16 bit immediate.
    int imm32 = signExtend16to32(imm16); //bits 15-0 sign extended
    fieldsOut -> imm32 = imm32;
    
	int addressBits = (instruction) & 0x3FFFFFF; //bits 25-0
    fieldsOut -> address = addressBits;
}
/**
 * This function will read the opcode/funct and assign all of the control bits for 
 * the control struct. It will do so by determining whether the instruction is 
 * in R/I format based on the opcode.
 * 
*/
int fill_CPUControl(InstructionFields *fields, CPUControl *controlOut){
    int opcode = fields -> opcode;
    int funct = fields -> funct;
    // Only turned on for SLL.
    controlOut -> extra1 = 0;
    // Check if we are dealing with R format. Opcode will be 0 if true.
    if (opcode==0x00){
        // Within this if statement, we assign all R format values.
        // Check funct to determine what operation.

        // add. funct 32.
        if (funct==0x20){
            controlOut -> ALUsrc = 0;
            controlOut -> ALU.op = 2;
            controlOut -> ALU.bNegate = 0;
            controlOut -> memRead = 0;
            controlOut -> memWrite = 0;
            controlOut -> memToReg = 0;
            controlOut -> regDst = 1;
            controlOut -> regWrite = 1;
            controlOut -> branch = 0;
            controlOut -> jump = 0;
        }
        // addu. funct 33.
        else if (funct==0x21){
            controlOut -> ALUsrc = 0;
            controlOut -> ALU.op = 2;
            controlOut -> ALU.bNegate = 0;
            controlOut -> memRead = 0;
            controlOut -> memWrite = 0;
            controlOut -> memToReg = 0;
            controlOut -> regDst = 1;
            controlOut -> regWrite = 1;
            controlOut -> branch = 0;
            controlOut -> jump = 0;
        }
        // sub. funct 34.
        else if (funct==0x22){
            controlOut -> ALUsrc = 0;
            controlOut -> ALU.op = 2;
            controlOut -> ALU.bNegate = 1;
            controlOut -> memRead = 0;
            controlOut -> memWrite = 0;
            controlOut -> memToReg = 0;
            controlOut -> regDst = 1;
            controlOut -> regWrite = 1;
            controlOut -> branch = 0;
            controlOut -> jump = 0;
        }
        // subu. funct 35.
        else if (funct==0x23){
            controlOut -> ALUsrc = 0;
            controlOut -> ALU.op = 2;
            controlOut -> ALU.bNegate = 1;
            controlOut -> memRead = 0;
            controlOut -> memWrite = 0;
            controlOut -> memToReg = 0;
            controlOut -> regDst = 1;
            controlOut -> regWrite = 1;
            controlOut -> branch = 0;
            controlOut -> jump = 0;
        }
        // and. funct 36.
        else if (funct==0x24){
            controlOut -> ALUsrc = 0;
            controlOut -> ALU.op = 0;
            controlOut -> ALU.bNegate = 0;
            controlOut -> memRead = 0;
            controlOut -> memWrite = 0;
            controlOut -> memToReg = 0;
            controlOut -> regDst = 1;
            controlOut -> regWrite = 1;
            controlOut -> branch = 0;
            controlOut -> jump = 0;
        }
        // or. funct 37.
        else if (funct==0x25){
            controlOut -> ALUsrc = 0;
            controlOut -> ALU.op = 1;
            controlOut -> ALU.bNegate = 0;
            controlOut -> memRead = 0;
            controlOut -> memWrite = 0;
            controlOut -> memToReg = 0;
            controlOut -> regDst = 1;
            controlOut -> regWrite = 1;
            controlOut -> branch = 0;
            controlOut -> jump = 0;
        }
        // xor. funct 38.
        else if (funct==0x26){
            controlOut -> ALUsrc = 0;
            controlOut -> ALU.op = 4;
            controlOut -> ALU.bNegate = 0;
            controlOut -> memRead = 0;
            controlOut -> memWrite = 0;
            controlOut -> memToReg = 0;
            controlOut -> regDst = 1;
            controlOut -> regWrite = 1;
            controlOut -> branch = 0;
            controlOut -> jump = 0;
        }
        // slt. funct 42.
        else if (funct==0x2A){
            controlOut -> ALUsrc = 0;
            controlOut -> ALU.op = 3;
            controlOut -> ALU.bNegate = 1;
            controlOut -> memRead = 0;
            controlOut -> memWrite = 0;
            controlOut -> memToReg = 0;
            controlOut -> regDst = 1;
            controlOut -> regWrite = 1;
            controlOut -> branch = 0;
            controlOut -> jump = 0;
        }
        // EXTRA R FORMAT INSTRUCTION.
        //sll.
        else if (funct==0x00){
            controlOut -> ALUsrc = 0;
            controlOut -> ALU.op = 5;
            controlOut -> ALU.bNegate = 0;
            controlOut -> memRead = 0;
            controlOut -> memWrite = 0;
            controlOut -> memToReg = 0;
            controlOut -> regDst = 1;
            controlOut -> regWrite = 1;
            controlOut -> branch = 0;
            controlOut -> jump = 0;
            controlOut -> extra1 = 1;
        }
        // If it is R format but no valid function, return 0.
        else {
            return 0;
        }
    }

    // For I format, we just check the opcode directly.

    // lw.
    else if (opcode==0x23){
        controlOut -> ALUsrc = 1;
        controlOut -> ALU.op = 2;
        controlOut -> ALU.bNegate = 0;
        controlOut -> memRead = 1;
        controlOut -> memWrite = 0;
        controlOut -> memToReg = 1;
        controlOut -> regDst = 0;
        controlOut -> regWrite = 1;
        controlOut -> branch = 0;
        controlOut -> jump = 0;
    }
    //sw.
    else if (opcode==0x2B){
        controlOut -> ALUsrc = 1;
        controlOut -> ALU.op = 2;
        controlOut -> ALU.bNegate = 0;
        controlOut -> memRead = 0;
        controlOut -> memWrite = 1;
        controlOut -> memToReg = 0;
        controlOut -> regDst = 0;
        controlOut -> regWrite = 0;
        controlOut -> branch = 0;
        controlOut -> jump = 0;
    }
    // beq.
    else if (opcode==0x04){
        controlOut -> ALUsrc = 0;
        controlOut -> ALU.op = 2;
        controlOut -> ALU.bNegate = 1;
        controlOut -> memRead = 0;
        controlOut -> memWrite = 0;
        controlOut -> memToReg = 0;
        controlOut -> regDst = 0;
        controlOut -> regWrite = 0;
        controlOut -> branch = 1;
        controlOut -> jump = 0;
    }
    // j.
    else if (opcode==0x02){
        controlOut -> ALUsrc = 0;
        controlOut -> ALU.op = 0;
        controlOut -> ALU.bNegate = 0;
        controlOut -> memRead = 0;
        controlOut -> memWrite = 0;
        controlOut -> memToReg = 0;
        controlOut -> regDst = 0;
        controlOut -> regWrite = 0;
        controlOut -> branch = 0;
        controlOut -> jump = 1;
    }
    // addi.
    else if (opcode==0x08){
        controlOut -> ALUsrc = 1;
        controlOut -> ALU.op = 2;
        controlOut -> ALU.bNegate = 0;
        controlOut -> memRead = 0;
        controlOut -> memWrite = 0;
        controlOut -> memToReg = 0;
        controlOut -> regDst = 0;
        controlOut -> regWrite = 1;
        controlOut -> branch = 0;
        controlOut -> jump = 0;
    }
    //addiu.
    else if (opcode==0x09){
        controlOut -> ALUsrc = 1;
        controlOut -> ALU.op = 2;
        controlOut -> ALU.bNegate = 0;
        controlOut -> memRead = 0;
        controlOut -> memWrite = 0;
        controlOut -> memToReg = 0;
        controlOut -> regDst = 0;
        controlOut -> regWrite = 1;
        controlOut -> branch = 0;
        controlOut -> jump = 0;
    }
    // slti
    else if (opcode==0x0A){
        controlOut -> ALUsrc = 1;
        controlOut -> ALU.op = 3;
        controlOut -> ALU.bNegate = 1;
        controlOut -> memRead = 0;
        controlOut -> memWrite = 0;
        controlOut -> memToReg = 0;
        controlOut -> regDst = 0;
        controlOut -> regWrite = 1;
        controlOut -> branch = 0;
        controlOut -> jump = 0;
    }

    // EXTRA I FORMAT INSTRUCTIONS.
    //andi.
    else if (opcode==0x0C){
        controlOut -> ALUsrc = 2;
        controlOut -> ALU.op = 0;
        controlOut -> ALU.bNegate = 0;
        controlOut -> memRead = 0;
        controlOut -> memWrite = 0;
        controlOut -> memToReg = 0;
        controlOut -> regDst = 0;
        controlOut -> regWrite = 1;
        controlOut -> branch = 0;
        controlOut -> jump = 0;
    }
    
    //bne. TRYING WITH NEW ALU OP.
    else if (opcode==0x05){
        controlOut -> ALUsrc = 0;
        controlOut -> ALU.op = 6;
        controlOut -> ALU.bNegate = 0;
        controlOut -> memRead = 0;
        controlOut -> memWrite = 0;
        controlOut -> memToReg = 0;
        controlOut -> regDst = 0;
        controlOut -> regWrite = 0;
        controlOut -> branch = 1;
        controlOut -> jump = 0;
    }
    else {
        return 0;
    }
    return 1;
}

// This function reads and returns the proper word out of the instruction memory.
WORD getInstruction(WORD curPC, WORD *instructionMemory) {
    return instructionMemory[curPC/4];
}

// This function returns the first word which will be used as input for the ALU.
WORD getALUinput1(CPUControl *controlIn,
                  InstructionFields *fieldsIn, WORD rsVal, WORD rtVal, 
                  WORD reg32, WORD reg33, WORD oldPC) {
    // If statement to check for SLL.
    if (controlIn -> extra1 == 1) {
        return fieldsIn -> shamt;
    }
    else {
        return rsVal;
    }
    
}

// This function returns the second word which will be used as input for the ALU.
WORD getALUinput2(CPUControl *controlIn,
                  InstructionFields *fieldsIn,
                  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33,
                  WORD oldPC) {
    // Return value will differ depending on R/I format.

    // If statement for R format. R format would use rtVal as input.
    if (controlIn -> ALUsrc==0) {
        return rtVal;
    }
    // Else if statement only for ANDI.***
    else if (controlIn -> ALUsrc==2) {
        return (fieldsIn -> imm16);
    }
    // Else statement to cover the rest of I formats.
    else {
        return (fieldsIn -> imm32);
    }
}

/**This function is where we implement the ALU.
 * Must make if conditions for every aluOp, *INCLUDING EXTRAS*.
 */
void execute_ALU(CPUControl *controlIn,
                 WORD input1, WORD input2,
                 ALUResult  *aluResultOut) {
    int currOp = controlIn -> ALU.op;

    // AND operation.
    if (currOp==0){

        // Mask input2 as 32 bit int.
        // input2 = input2&0x0000FFFF;
        aluResultOut -> result = input1&input2;
    }

    // OR operation.
    else if (currOp==1) {
        aluResultOut -> result = input1|input2;
    }

    // ADD/SUB operations.
    else if (currOp==2) {
        // ADD and SUB operations.
        // Determine whether aluOp is ADD or SUB based on bNegate.

        // ADD operation.
        if (controlIn -> ALU.bNegate == 0) {
            aluResultOut -> result = input1+input2;
        }
        // SUB operation.
        else {
            aluResultOut -> result = input1-input2;
        }
        
    }
    // SLT/SLTI operation.
    else if (currOp==3) {
        int signCheck = input1-input2;
        // If slt is true.
        if (signCheck<0) {
            aluResultOut -> result = 1;
        }
        // If slt is not true.
        else {
            aluResultOut -> result = 0;
        }
    }
    // XOR operation.
    else if (currOp==4) {
        aluResultOut -> result = input1^input2;
    }
    // EXTRA OPERATION: Needed for SLL.
    else if (currOp==5) {
        aluResultOut -> result = input2<<input1;
    }
    // EXTRA OPERATION: Needed for bne.
    else if (currOp==6) {
        if (input1==input2) {
            aluResultOut -> result = 1;
        }
        else {
            aluResultOut -> result = 0;
        }
    }
    // Finally set aluZero based on the result.
    if (aluResultOut -> result == 0) {
        aluResultOut -> zero = 1;
    }
    else {
        aluResultOut -> zero = 0;
    }
}

// This function will implement the data memory unit.
void execute_MEM(CPUControl *controlIn,
                 ALUResult  *aluResultIn,
                 WORD        rsVal, WORD rtVal,
                 WORD       *memory,
                 MemResult  *resultOut) {
    int imm = aluResultIn -> result;
    // First check if we are not reading from memory.
    if (controlIn -> memRead == 0) {
        resultOut -> readVal = 0;
    }
    // If statement if we are reading from memory.
    else if (controlIn -> memRead == 1) {
        resultOut -> readVal =  memory[imm/4];
    }
    // Check if we are writing to memory.
    // If we are, we will be using the rtVal.
    if (controlIn -> memWrite == 1) {
        memory[imm/4] = rtVal;
    }
}

// This function will implement the appropriate logic to return the new PC.
WORD getNextPC(InstructionFields *fields, CPUControl *controlIn, int aluZero,
               WORD rsVal, WORD rtVal,
               WORD oldPC) {
    // If statement to cover JUMP.
    if (controlIn -> jump == 1 ) {
        int mask = 0xF0000000;
        int updatedAddress = fields -> address<<2;
        int nextPC = (oldPC & mask) | (updatedAddress & ~mask);
        return nextPC; 
    }
    // If statement to cover BRANCH.
    if (controlIn -> branch == 1 && aluZero==1) {
        int updatedPC = oldPC+4;
        int updatedAddress = fields -> imm32<<2;
        return updatedPC + updatedAddress;
    }
    return oldPC+4;
}

// This function is where writing to registers takes place. Final stage of processor.
void execute_updateRegs(InstructionFields *fields, CPUControl *controlIn,
                        ALUResult  *aluResultIn, MemResult *memResultIn,
                        WORD       *regs) {
    int currOp = fields -> opcode;
    int funct = fields -> funct;
    // Only taking action on registers if regWrite is true.
    if (controlIn -> regWrite == 1) {
        // If statement for all R formats, will deal with rd.
        if (controlIn -> regDst == 1) {
            regs[fields -> rd] = aluResultIn -> result;
        }
        else if (controlIn -> memToReg == 1) {
            // lw os only operation using memToReg.
            regs[fields -> rt] = memResultIn -> readVal; //changed to mem.
        }
        //Else statement for rest of I formats.
        else {
            regs[fields -> rt] = aluResultIn -> result;
        }
    }
}