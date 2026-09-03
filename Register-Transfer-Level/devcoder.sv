// ============================================================
// RISC-9 - Instruction Decoder
// ============================================================

module decoder (
    input  logic [31:0] instruction,

    output logic [6:0] opcode,
    output logic [4:0] rd,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [2:0] funct3,
    output logic [6:0] funct7
);

    // Extract opcode
    assign opcode = instruction[6:0];

    // Destination register
    assign rd = instruction[11:7];

    // Function field
    assign funct3 = instruction[14:12];

    // First source register
    assign rs1 = instruction[19:15];

    // Second source register
    assign rs2 = instruction[24:20];

    // Additional function field
    assign funct7 = instruction[31:25];

endmodule


// ============================================================
// JAVA EQUIVALENT - FOR UNDERSTANDING ONLY
// ============================================================

/*
class Decoder {

    int instruction;

    int opcode;
    int rd;
    int rs1;
    int rs2;
    int funct3;
    int funct7;

    void decode() {

        opcode = instruction & 0x7F;

        rd = (instruction >> 7) & 0x1F;

        funct3 = (instruction >> 12) & 0x07;

        rs1 = (instruction >> 15) & 0x1F;

        rs2 = (instruction >> 20) & 0x1F;

        funct7 = (instruction >> 25) & 0x7F;
    }
}
*/