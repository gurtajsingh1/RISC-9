// ============================================================
// RISC-9 - Program Counter
// ============================================================

module program_counter (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] next_pc,
    output logic [31:0] pc
);

    // PC changes at every rising clock edge
    // Reset makes PC start from address 0
    always_ff @(posedge clk or posedge reset) begin

        if (reset)
            pc <= 32'b0;
        else
            pc <= next_pc;

    end

endmodule


// ============================================================
// JAVA EQUIVALENT - FOR UNDERSTANDING ONLY
// ============================================================

/*
class ProgramCounter {

    boolean clk;
    boolean reset;

    int nextPc;
    int pc;

    void update() {

        if (reset)
            pc = 0;
        else
            pc = nextPc;
    }
}
*/