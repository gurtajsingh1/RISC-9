// ============================================================
// RISC-9 - Register File
// ============================================================

module register_file (
    input  logic        clk,
    input  logic        reset,
    input  logic        reg_write,

    input  logic [4:0]  rs1,
    input  logic [4:0]  rs2,
    input  logic [4:0]  rd,

    input  logic [31:0] write_data,

    output logic [31:0] read_data1,
    output logic [31:0] read_data2
);

    // 32 registers
    // Each register is 32 bits
    logic [31:0] registers [0:31];

    // Register write operation
    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin

            // Reset all registers
            for (int i = 0; i < 32; i++)
                registers[i] <= 32'b0;

        end

        else if (reg_write && rd != 5'b0) begin

            // x0 cannot be changed
            registers[rd] <= write_data;

        end

    end

    // Read first register
    assign read_data1 =
        (rs1 == 5'b0) ? 32'b0 : registers[rs1];

    // Read second register
    assign read_data2 =
        (rs2 == 5'b0) ? 32'b0 : registers[rs2];

endmodule


// ============================================================
// JAVA EQUIVALENT - FOR UNDERSTANDING ONLY
// ============================================================

/*
class RegisterFile {

    int[] registers = new int[32];

    boolean regWrite;

    int rs1;
    int rs2;
    int rd;

    int writeData;

    int readData1;
    int readData2;

    void reset() {

        for (int i = 0; i < 32; i++)
            registers[i] = 0;
    }

    void write() {

        if (regWrite && rd != 0)
            registers[rd] = writeData;
    }

    void read() {

        if (rs1 == 0)
            readData1 = 0;
        else
            readData1 = registers[rs1];

        if (rs2 == 0)
            readData2 = 0;
        else
            readData2 = registers[rs2];
    }
}
*/