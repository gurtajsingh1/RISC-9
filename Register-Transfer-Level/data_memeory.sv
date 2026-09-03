// ============================================================
// RISC-9 - Data Memory
// ============================================================

module data_memory (
    input  logic        clk,

    input  logic        mem_read,
    input  logic        mem_write,

    input  logic [31:0] address,
    input  logic [31:0] write_data,

    output logic [31:0] read_data
);

    // 256 memory locations
    // Each location contains 32 bits
    logic [31:0] memory [0:255];

    // Read data
    assign read_data =
        mem_read
        ? memory[address[9:2]]
        : 32'b0;

    // Write data on rising clock edge
    always_ff @(posedge clk) begin

        if (mem_write)
            memory[address[9:2]] <= write_data;

    end

endmodule


// ============================================================
// JAVA EQUIVALENT - FOR UNDERSTANDING ONLY
// ============================================================

/*
class DataMemory {

    int[] memory = new int[256];

    boolean memRead;
    boolean memWrite;

    int address;
    int writeData;
    int readData;

    void write() {

        if (memWrite) {

            int index = address / 4;

            memory[index] = writeData;
        }
    }

    void read() {

        if (memRead) {

            int index = address / 4;

            readData = memory[index];

        } else {

            readData = 0;
        }
    }
}
*/