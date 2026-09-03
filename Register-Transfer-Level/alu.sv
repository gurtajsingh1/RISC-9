// ============================================================
// RISC-9 - Arithmetic Logic Unit
// ============================================================

module alu (
    input  logic [31:0] a,
    input  logic [31:0] b,

    input  logic [3:0] alu_control,

    output logic [31:0] result,
    output logic        zero
);

    localparam ADD    = 4'b0000;
    localparam SUB    = 4'b0001;
    localparam AND_OP = 4'b0010;
    localparam OR_OP  = 4'b0011;
    localparam XOR_OP = 4'b0100;
    localparam SLT    = 4'b0101;

    always_comb begin

        case (alu_control)

            ADD:
                result = a + b;

            SUB:
                result = a - b;

            AND_OP:
                result = a & b;

            OR_OP:
                result = a | b;

            XOR_OP:
                result = a ^ b;

            SLT:
                result =
                    ($signed(a) < $signed(b))
                    ? 32'b1
                    : 32'b0;

            default:
                result = 32'b0;

        endcase

    end

    // Zero flag
    assign zero = (result == 32'b0);

endmodule


// ============================================================
// JAVA EQUIVALENT - FOR UNDERSTANDING ONLY
// ============================================================

/*
class ALU {

    static final int ADD = 0;
    static final int SUB = 1;
    static final int AND_OP = 2;
    static final int OR_OP = 3;
    static final int XOR_OP = 4;
    static final int SLT = 5;

    int a;
    int b;

    int result;
    boolean zero;

    void calculate(int control) {

        switch (control) {

            case ADD:
                result = a + b;
                break;

            case SUB:
                result = a - b;
                break;

            case AND_OP:
                result = a & b;
                break;

            case OR_OP:
                result = a | b;
                break;

            case XOR_OP:
                result = a ^ b;
                break;

            case SLT:
                result = a < b ? 1 : 0;
                break;

            default:
                result = 0;
        }

        zero = result == 0;
    }
}
*/