// ============================================================
// RISC-9 - Instruction Memory
// ============================================================

module instruction_memory (
    input  logic [31:0] address,
    output logic [31:0] instruction
);

    // 256 memory locations
    // Each location stores one 32-bit instruction
    logic [31:0] memory [0:255];

    // Each RISC-V instruction is 4 bytes
    // Therefore lower 2 address bits are ignored
    assign instruction = memory[address[9:2]];

endmodule


// ============================================================
// JAVA EQUIVALENT - FOR UNDERSTANDING ONLY
// ============================================================

/*
class InstructionMemory {

    int[] memory = new int[256];

    int getInstruction(int address) {

        int index = address / 4;

        return memory[index];
    }
}
*/