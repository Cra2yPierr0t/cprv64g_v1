module cprv_alu #(
    parameter OPCODE_WIDTH  = 7,
    parameter FUNCT3_WIDTH  = 3,
    parameter FUNCT7_WIDTH  = 7,
    parameter DATA_WIDTH    = 64,
    parameter IMM_WIDTH     = 32,
    parameter REGADDR_WIDTH = 5,
    parameter DW_WIDTH      = 64,
    parameter W_WIDTH       = 32
)(
    input   logic [OPCODE_WIDTH-1:0]    opcode,
    input   logic [FUNCT3_WIDTH-1:0]    funct3,
    input   logic [FUNCT7_WIDTH-1:0]    funct7,
    input   logic [DATA_WIDTH-1:0]      data1,
    input   logic [DATA_WIDTH-1:0]      data2,
    input   logic [IMM_WIDTH-1:0]       imm,
    input   logic [REGADDR_WIDTH-1:0]   rd,
    output  logic [DATA_WIDTH-1:0]      alu_out
);

    parameter OP        = 7'b01_100_11;
    parameter OP_IMM    = 7'b00_100_11;
    parameter OP_32     = 7'b01_110_11;
    parameter OP_IMM_32 = 7'b00_110_11;
    parameter LOAD      = 7'b00_000_11;
    parameter STORE     = 7'b01_000_11;

    parameter ADD_SRL   = 7'b0000000;
    parameter SUB_SRA   = 7'b0100000;

    parameter ADD_OP    = 3'b000;
    parameter SLL_OP    = 3'b001;
    parameter SLT_OP    = 3'b010;
    parameter SLTU_OP   = 3'b011;
    parameter XOR_OP    = 3'b100;
    parameter SRL_OP    = 3'b101;
    parameter OR_OP     = 3'b110;
    parameter AND_OP    = 3'b111;
    parameter SUB_OP    = 3'b000;
    parameter SRA_OP    = 3'b101;

    parameter ADDI_OP   = 3'b000;
    parameter SLTI_OP   = 3'b010;
    parameter SLTIU_OP  = 3'b011;
    parameter XORI_OP   = 3'b100;
    parameter ORI_OP    = 3'b110;
    parameter ANDI_OP   = 3'b111;
    parameter SLLI_OP   = 3'b001;
    parameter SRLI_SRAI = 3'b101;

    parameter SRLI      = 7'b0000000;
    parameter SRAI      = 7'b0100000;

    parameter ADDW_SRLW = 7'b0000000;
    parameter SUBW_SRAW = 7'b0100000;

    parameter ADDW_OP   = 3'b000;
    parameter SLLW_OP   = 3'b001;
    parameter SRLW_OP   = 3'b101;

    parameter SUBW_OP   = 3'b000;
    parameter SRAW_OP   = 3'b101;

    parameter ADDIW_OP  = 3'b000;
    parameter SLLIW_OP  = 3'b001;
    parameter SRLIW_SRAIW  = 3'b101;

    parameter SRLIW_OP  = 7'b0000000;
    parameter SRAIW_OP  = 7'b0100000;

    logic [DW_WIDTH*2-1:0] mul_buf;
    logic [DW_WIDTH-1:0] mulw_buf;

    always_comb begin
        case(opcode)
            OP          : begin
                case(funct7)
                    // RV64I
                    ADD_SRL : begin
                        case(funct3)
                            ADD_OP  : alu_out = signed'(data1) + signed'(data2);
                            SLL_OP  : alu_out = data1 >> data2;
                            SLT_OP  : alu_out = DW_WIDTH'(signed'(data2) > signed'(data1));
                            SLTU_OP : alu_out = DW_WIDTH'(unsigned'(data2) > unsigned'(data1));
                            XOR_OP  : alu_out = data1 ^ data2;
                            OR_OP   : alu_out = data1 | data2;
                            AND_OP  : alu_out = data1 & data2;
                            SRL_OP  : alu_out = data1 >> DW_WIDTH'(data2[4:0]);
                            default : alu_out = 'hx;
                        endcase
                    end
                    SUB_SRA : begin
                        case(funct3)
                            SUB_OP  : alu_out = signed'(data1) - signed'(data2);
                            SRA_OP  : alu_out = data1 >>> DW_WIDTH'(data2[4:0]);
                            default : alu_out = 'hx;
                        endcase
                    end
                    // RV64M
                    /*
                    MULDIV : begin
                        case(funct3)
                            MUL_OP  : begin
                                mul_buf = signed'(data1) * signed'(data2);
                                alu_out = mul_buf[DW_WIDTH-1:0];
                            end
                            MULH_OP : begin
                                mul_buf = signed'(data1) * signed'(data2);
                                alu_out = mul_buf[DW_WIDTH*2-1:DW_WIDTH];
                            end
                            MULHSU_OP : begin
                                mul_buf = signed'(data1) * unsigned'(data2);
                                alu_out = mul_buf[DW_WIDTH*2-1:DW_WIDTH];
                            end
                            MULHU_OP  : begin
                                mul_buf = unsigned'(data1) * unsigned'(data2);
                                alu_out = mul_buf[DW_WIDTH*2-1:DW_WIDTH];
                            end
                            DIV_OP  : alu_out = signed'(data1) / signed'(data2);
                            DIVU_OP : alu_out = unsigned'(data1) / unsigned'(data2);
                            REM_OP  : alu_out = signed'(data1) % signed'(data2);
                            REMU_OP : alu_out = unsigned'(data1) % unsigned'(data2);
                        endcase
                    end
                    */
                endcase
            end
            OP_IMM      : begin
                case(funct3)
                    // RV64I
                    ADDI_OP : alu_out = DW_WIDTH'(signed'(imm)) + signed'(data1); 
                    SLTI_OP : alu_out = DW_WIDTH'(DW_WIDTH'(signed'(imm)) > signed'(data1));
                    SLTIU_OP: alu_out = DW_WIDTH'(unsigned'(DW_WIDTH'(signed'(imm))) > unsigned'(data1));
                    XORI_OP : alu_out = DW_WIDTH'(signed'(imm)) ^ data1;
                    ORI_OP  : alu_out = DW_WIDTH'(signed'(imm)) | data1;
                    ANDI_OP : alu_out = DW_WIDTH'(signed'(imm)) & data1;
                    SLLI_OP : alu_out = data1 << DW_WIDTH'(imm[4:0]);
                    SRLI_SRAI : begin
                        case(funct7)
                            SRLI : alu_out = data1 >> DW_WIDTH'(imm[4:0]);
                            SRAI : alu_out = data1 >>> DW_WIDTH'(imm[4:0]);
                            default : alu_out = 'hx;
                        endcase
                    end
                endcase
            end
            OP_32       : begin
                case(funct7)
                    // RV64I
                    ADDW_SRLW : begin
                        case(funct3)
                            ADDW_OP : alu_out = DW_WIDTH'(signed'(W_WIDTH'(data1 + data2)));
                            SLLW_OP : alu_out = DW_WIDTH'(signed'(W_WIDTH'(data1 << DW_WIDTH'(data2[4:0]))));
                            SRLW_OP : alu_out = DW_WIDTH'(signed'(W_WIDTH'(data1 >> DW_WIDTH'(data2[4:0]))));
                            default : alu_out = 'hx;
                        endcase
                    end
                    SUBW_SRAW : begin
                        case(funct3)
                            SUBW_OP : alu_out = DW_WIDTH'(signed'(W_WIDTH'(data1 - data2)));
                            SRAW_OP : alu_out = DW_WIDTH'(signed'(W_WIDTH'(data1 >>> DW_WIDTH'(data2[4:0]))));
                            default : alu_out = 'hx;
                        endcase
                    end
                    // RV64M
                    /*
                    MULDIV : begin
                        MULW_OP : begin
                            mulw_buf = signed'(W_WIDTH'(data1)) * signed'(W_WIDTH(data2));
                            alu_out = DW_WIDTH'(signed'(mulw_buf[W_WIDTH-1:0]));
                        end
                        DIVW_OP : alu_out = DW_WIDTH'(signed'(signed'(W_WIDTH'(data1)) / signed'(W_WIDTH'(data2))));
                        DIVUW_OP : alu_out = DW_WIDTH'(unsigned'(W_WIDTH'(data1)) / unsigned'(W_WIDTH'(data2)));
                        REMW_OP : alu_out = DW_WIDTH'(signed'(signed'(W_WIDTH'(data1)) % signed'(W_WIDTH'(data2))));
                        REMUW_OP : alu_out = DW_WIDTH'(unsigned'(W_WIDTH'(data1)) % unsigned'(W_WIDTH'(data2)));
                        default :
                    end
                    */
                    default : alu_out = 'hx;
                endcase
            end
            OP_IMM_32   : begin
                case(funct3)
                    // RV64I
                    ADDIW_OP : alu_out = DW_WIDTH'(signed'(W_WIDTH'(data1 + DW_WIDTH'(signed'(imm)))));
                    SLLIW_OP : alu_out = DW_WIDTH'(signed'(W_WIDTH'(data1 << DW_WIDTH'(imm[4:0]))));
                    SRLIW_SRAIW : begin
                        case(funct7)
                            SRLIW_OP : alu_out = DW_WIDTH'(signed'(W_WIDTH'(data1 >> DW_WIDTH'(imm[4:0]))));
                            SRAIW_OP : alu_out = DW_WIDTH'(signed'(W_WIDTH'(data1 >>> DW_WIDTH'(imm[4:0]))));
                            default : alu_out = 'hx;
                        endcase
                    end
                    default : alu_out = 'hx;
                endcase
            end
            LOAD    : begin
                alu_out = signed'(data1) + DW_WIDTH'(signed'(imm));
            end
            STORE   : begin
                alu_out = signed'(data1) + DW_WIDTH'(signed'({funct7,rd}));
            end
            default : alu_out = 'hx;
        endcase
    end
endmodule
