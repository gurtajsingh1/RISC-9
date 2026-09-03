// ============================================================
// RISC-9 - CPU
// ============================================================

module cpu (
    input logic clk,
    input logic reset
);

    // ========================================================
    // PROGRAM COUNTER
    // ========================================================

    logic [31:0] pc;
    logic [31:0] next_pc;


    // ========================================================
    // INSTRUCTION
    // ========================================================

    logic [31:0] instruction;


    // ========================================================
    // INSTRUCTION FIELDS
    // ========================================================

    logic [6:0] opcode;
    logic [4:0] rd;
    logic [4:0] rs1;
    logic [4:0] rs2;

    logic [2:0] funct3;
    logic [6:0] funct7;


    // ========================================================
    // IMMEDIATE
    // ========================================================

    logic [31:0] immediate;
    logic [2:0] imm_type;


    // ========================================================
    // REGISTER FILE
    // ========================================================

    logic [31:0] read_data1;
    logic [31:0] read_data2;


    // ========================================================
    // ALU
    // ========================================================

    logic [31:0] alu_input_b;
    logic [31:0] alu_result;
    logic        alu_zero;


    // ========================================================
    // DATA MEMORY
    // ========================================================

    logic [31:0] memory_data;


    // ========================================================
    // WRITE BACK
    // ========================================================

    logic [31:0] write_back_data;


    // ========================================================
    // CONTROL SIGNALS
    // ========================================================

    logic       reg_write;
    logic       alu_src;
    logic       mem_read;
    logic       mem_write;
    logic       mem_to_reg;
    logic       branch;

    logic [3:0] alu_control;


    // ========================================================
    // NEXT PC
    // ========================================================

    // Move to the next 32-bit instruction
    assign next_pc = pc + 32'd4;


    // ========================================================
    // ALU INPUT SELECTION
    // ========================================================

    // alu_src = 0 → use register rs2
    // alu_src = 1 → use immediate

    assign alu_input_b =
        alu_src
        ? immediate
        : read_data2;


    // ========================================================
    // WRITE BACK SELECTION
    // ========================================================

    // mem_to_reg = 0 → ALU result
    // mem_to_reg = 1 → Memory data

    assign write_back_data =
        mem_to_reg
        ? memory_data
        : alu_result;


    // ========================================================
    // IMMEDIATE TYPE
    // ========================================================

    // Store → S-type
    // Branch → B-type
    // Others → I-type

    assign imm_type =
        (opcode == 7'b0100011) ? 3'b001 :
        (opcode == 7'b1100011) ? 3'b010 :
        3'b000;


    // ========================================================
    // PROGRAM COUNTER
    // ========================================================

    program_counter pc_unit (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );


    // ========================================================
    // INSTRUCTION MEMORY
    // ========================================================

    instruction_memory instruction_mem (
        .address(pc),
        .instruction(instruction)
    );


    // ========================================================
    // DECODER
    // ========================================================

    decoder decoder_unit (
        .instruction(instruction),

        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),

        .funct3(funct3),
        .funct7(funct7)
    );


    // ========================================================
    // IMMEDIATE GENERATOR
    // ========================================================

    immediate_generator immediate_unit (
        .instruction(instruction),
        .imm_type(imm_type),
        .immediate(immediate)
    );


    // ========================================================
    // REGISTER FILE
    // ========================================================

    register_file registers (
        .clk(clk),
        .reset(reset),

        .reg_write(reg_write),

        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .write_data(write_back_data),

        .read_data1(read_data1),
        .read_data2(read_data2)
    );


    // ========================================================
    // CONTROL UNIT
    // ========================================================

    control_unit control (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .reg_write(reg_write),
        .alu_src(alu_src),

        .mem_read(mem_read),
        .mem_write(mem_write),

        .mem_to_reg(mem_to_reg),

        .branch(branch),

        .alu_control(alu_control)
    );


    // ========================================================
    // ALU
    // ========================================================

    alu alu_unit (
        .a(read_data1),
        .b(alu_input_b),

        .alu_control(alu_control),

        .result(alu_result),
        .zero(alu_zero)
    );


    // ========================================================
    // DATA MEMORY
    // ========================================================

    data_memory data_mem (
        .clk(clk),

        .mem_read(mem_read),
        .mem_write(mem_write),

        .address(alu_result),
        .write_data(read_data2),

        .read_data(memory_data)
    );

endmodule


// ============================================================
// JAVA EQUIVALENT - FOR UNDERSTANDING ONLY
// ============================================================

/*
class CPU {

    ProgramCounter pcUnit;
    InstructionMemory instructionMemory;
    Decoder decoder;
    ImmediateGenerator immediateGenerator;
    RegisterFile registers;
    ControlUnit controlUnit;
    ALU alu;
    DataMemory dataMemory;

    int pc;
    int nextPc;

    int instruction;

    int opcode;
    int rd;
    int rs1;
    int rs2;
    int funct3;
    int funct7;

    int immediate;

    int readData1;
    int readData2;

    int aluInputB;
    int aluResult;

    int memoryData;
    int writeBackData;

    boolean regWrite;
    boolean aluSrc;
    boolean memRead;
    boolean memWrite;
    boolean memToReg;
    boolean branch;

    int aluControl;

    void execute() {

        nextPc = pc + 4;

        decoder.instruction = instruction;
        decoder.decode();

        opcode = decoder.opcode;
        rd = decoder.rd;
        rs1 = decoder.rs1;
        rs2 = decoder.rs2;
        funct3 = decoder.funct3;
        funct7 = decoder.funct7;

        controlUnit.decode(
            opcode,
            funct3,
            funct7
        );

        regWrite = controlUnit.regWrite;
        aluSrc = controlUnit.aluSrc;
        memRead = controlUnit.memRead;
        memWrite = controlUnit.memWrite;
        memToReg = controlUnit.memToReg;
        branch = controlUnit.branch;
        aluControl = controlUnit.aluControl;

        registers.rs1 = rs1;
        registers.rs2 = rs2;

        registers.read();

        readData1 = registers.readData1;
        readData2 = registers.readData2;

        if (aluSrc)
            aluInputB = immediate;
        else
            aluInputB = readData2;

        alu.a = readData1;
        alu.b = aluInputB;

        alu.calculate(aluControl);

        aluResult = alu.result;

        dataMemory.address = aluResult;
        dataMemory.writeData = readData2;
        dataMemory.memRead = memRead;
        dataMemory.memWrite = memWrite;

        dataMemory.read();

        memoryData = dataMemory.readData;

        if (memToReg)
            writeBackData = memoryData;
        else
            writeBackData = aluResult;

        registers.rd = rd;
        registers.writeData = writeBackData;
        registers.regWrite = regWrite;

        registers.write();

        pc = nextPc;
    }
}
*/