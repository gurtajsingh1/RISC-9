// ============================================================
// RISC-9 - Control Unit
// ============================================================

module control_unit (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,

    output logic       reg_write,
    output logic       alu_src,
    output logic       mem_read,
    output logic       mem_write,
    output logic       mem_to_reg,
    output logic       branch,

    output logic [3:0] alu_control
);

    always_comb begin

        // Default values
        reg_write   = 1'b0;
        alu_src     = 1'b0;
        mem_read    = 1'b0;
        mem_write   = 1'b0;
        mem_to_reg  = 1'b0;
        branch      = 1'b0;
        alu_control = 4'b0000;

        case (opcode)

            // =================================================
            // R-TYPE
            // =================================================

            7'b0110011: begin

                reg_write = 1'b1;

                case (funct3)

                    // ADD / SUB
                    3'b000:
                        alu_control =
                            (funct7 == 7'b0100000)
                            ? 4'b0001
                            : 4'b0000;

                    // AND
                    3'b111:
                        alu_control = 4'b0010;

                    // OR
                    3'b110:
                        alu_control = 4'b0011;

                    // XOR
                    3'b100:
                        alu_control = 4'b0100;

                    // SLT
                    3'b010:
                        alu_control = 4'b0101;

                    default:
                        alu_control = 4'b0000;

                endcase
            end


            // =================================================
            // I-TYPE ARITHMETIC
            // =================================================

            7'b0010011: begin

                reg_write = 1'b1;
                alu_src = 1'b1;

                case (funct3)

                    // ADDI
                    3'b000:
                        alu_control = 4'b0000;

                    // ANDI
                    3'b111:
                        alu_control = 4'b0010;

                    // ORI
                    3'b110:
                        alu_control = 4'b0011;

                    // XORI
                    3'b100:
                        alu_control = 4'b0100;

                    // SLTI
                    3'b010:
                        alu_control = 4'b0101;

                    default:
                        alu_control = 4'b0000;

                endcase
            end


            // =================================================
            // LOAD
            // =================================================

            7'b0000011: begin

                reg_write  = 1'b1;
                alu_src    = 1'b1;
                mem_read   = 1'b1;
                mem_to_reg = 1'b1;

                alu_control = 4'b0000;

            end


            // =================================================
            // STORE
            // =================================================

            7'b0100011: begin

                alu_src   = 1'b1;
                mem_write = 1'b1;

                alu_control = 4'b0000;

            end


            // =================================================
            // BRANCH
            // =================================================

            7'b1100011: begin

                branch = 1'b1;
                alu_control = 4'b0001;

            end


            default: begin

            end

        endcase

    end

endmodule


// ============================================================
// JAVA EQUIVALENT - FOR UNDERSTANDING ONLY
// ============================================================

/*
class ControlUnit {

    boolean regWrite;
    boolean aluSrc;
    boolean memRead;
    boolean memWrite;
    boolean memToReg;
    boolean branch;

    int aluControl;

    void decode(int opcode, int funct3, int funct7) {

        regWrite = false;
        aluSrc = false;
        memRead = false;
        memWrite = false;
        memToReg = false;
        branch = false;
        aluControl = 0;

        switch (opcode) {

            case 0b0110011:

                regWrite = true;

                if (funct3 == 0) {

                    if (funct7 == 0b0100000)
                        aluControl = 1;
                    else
                        aluControl = 0;

                }
                else if (funct3 == 7)
                    aluControl = 2;

                else if (funct3 == 6)
                    aluControl = 3;

                else if (funct3 == 4)
                    aluControl = 4;

                else if (funct3 == 2)
                    aluControl = 5;

                break;


            case 0b0010011:

                regWrite = true;
                aluSrc = true;

                if (funct3 == 0)
                    aluControl = 0;

                else if (funct3 == 7)
                    aluControl = 2;

                else if (funct3 == 6)
                    aluControl = 3;

                else if (funct3 == 4)
                    aluControl = 4;

                else if (funct3 == 2)
                    aluControl = 5;

                break;


            case 0b0000011:

                regWrite = true;
                aluSrc = true;
                memRead = true;
                memToReg = true;
                aluControl = 0;

                break;


            case 0b0100011:

                aluSrc = true;
                memWrite = true;
                aluControl = 0;

                break;


            case 0b1100011:

                branch = true;
                aluControl = 1;

                break;
        }
    }
}
*/