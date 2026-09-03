// ============================================================
// RISC-9 - Immediate Generator
// ============================================================

module immediate_generator (
    input  logic [31:0] instruction,
    input  logic [2:0]  imm_type,
    output logic [31:0] immediate
);

    localparam I_TYPE = 3'b000;
    localparam S_TYPE = 3'b001;
    localparam B_TYPE = 3'b010;
    localparam U_TYPE = 3'b011;
    localparam J_TYPE = 3'b100;

    always_comb begin

        case (imm_type)

            // I-type
            I_TYPE:
                immediate = {{20{instruction[31]}},
                             instruction[31:20]};

            // S-type
            S_TYPE:
                immediate = {{20{instruction[31]}},
                             instruction[31:25],
                             instruction[11:7]};

            // B-type
            B_TYPE:
                immediate = {{19{instruction[31]}},
                             instruction[31],
                             instruction[7],
                             instruction[30:25],
                             instruction[11:8],
                             1'b0};

            // U-type
            U_TYPE:
                immediate = {instruction[31:12], 12'b0};

            // J-type
            J_TYPE:
                immediate = {{11{instruction[31]}},
                             instruction[31],
                             instruction[19:12],
                             instruction[20],
                             instruction[30:21],
                             1'b0};

            default:
                immediate = 32'b0;

        endcase

    end

endmodule


// ============================================================
// JAVA EQUIVALENT - FOR UNDERSTANDING ONLY
// ============================================================

/*
class ImmediateGenerator {

    static final int I_TYPE = 0;
    static final int S_TYPE = 1;
    static final int B_TYPE = 2;
    static final int U_TYPE = 3;
    static final int J_TYPE = 4;

    int instruction;
    int immediate;

    void generate(int immType) {

        switch (immType) {

            case I_TYPE:
                immediate = instruction >> 20;
                break;

            case S_TYPE:
                immediate =
                    ((instruction >> 25) << 5)
                    | ((instruction >> 7) & 0x1F);
                break;

            case B_TYPE:
                immediate =
                    ((instruction >> 31) << 12)
                    | (((instruction >> 7) & 1) << 11)
                    | (((instruction >> 25) & 0x3F) << 5)
                    | (((instruction >> 8) & 0xF) << 1);
                break;

            case U_TYPE:
                immediate = instruction & 0xFFFFF000;
                break;

            case J_TYPE:
                immediate =
                    ((instruction >> 31) << 20)
                    | (((instruction >> 12) & 0xFF) << 12)
                    | (((instruction >> 20) & 1) << 11)
                    | (((instruction >> 21) & 0x3FF) << 1);
                break;

            default:
                immediate = 0;
        }
    }
}
*/