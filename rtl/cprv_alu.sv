module cprv_alu #(
)(
    input   logic [OPCODE_WIDTH-1:0]    opcode,
    input   logic [FUNCT3_WIDTH-1:0]    funct3,
    input   logic [FUNCT7_WIDTH-1:0]    funct7,
    input   logic [DATA_WIDTH-1:0]      data1,
    input   logic [DATA_WIDTH-1:0]      data2,
    input   logic [IMM_WIDTH-1:0]       imm,
    input   logic [REGADDR_WIDTH-1:0]   rd,
    output  logic [DATA_WIDTH-1:0]      alu_out,
);

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
                            SLTU_OP : alu_out = DW_WIDHT'(unsigned'(data2) > unsigned'(data1));
                            XOR_OP  : alu_out = data1 ^ data2;
                            OR_OP   : alu_out = data1 | data2;
                            AND_OP  : alu_out = data1 & data2;
                            SRL_OP  : alu_out = data1 >> DW_WIDTH'(data2[4:0]);
                        endcase
                    end
                    SUB_SRA : begin
                        case(funct3)
                            SUB_OP  : alu_out = signed'(data1) - signed'(data2);
                            SRA_OP  : alu_out = data1 >>> DW_WIDTH'(data2[4:0]);
                            default :
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
                            default :
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
                            SRLW_OP : alu_out = DW_WIDTH'(signed'(W_WIDTH(data1 >> DW_WIDTH'(data2[4:0]))));
                            default :
                        endcase
                    end
                    SUBW_SRAW : begin
                        case(funct3)
                            SUBW_OP : alu_out = DW_WIDTH'(signed'(W_WIDTH'(data1 - data2)));
                            SRAW_OP : alu_out = DW_WIDTH'(signed'(W_WIDTH(data1 >>> DW_WIDTH'(data2[4:0]))));
                            default : 
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
                    default :
                endcase
            end
            OP_IMM_32   : begin
                case(funct3)
                    // RV64I
                    ADDIW_OP : alu_out = DW_WIDTH'(signed'(W_WIDTH'(data1 + DW_WIDTH'(signed'(imm)))));
                    SLLIW_OP : alu_out = DW_WIDTH'(signed'(W_WIDTH'(data1 << DW_WIDTH'(imm[4:0]))));
                    SRLIW_SRAIW : begin
                        SRLIW_OP : alu_out = DW_WIDTH'(signed'(W_WIDTH(data1 >> DW_WIDTH'(imm[4:0]))));
                        SRAIW_OP : alu_out = DW_WIDTH'(signed'(W_WIDTH(data1 >>> DW_WIDTH'(imm[4:0]))));
                        default  :
                    end
                    default  :
                endcase
            end
            LOAD    : begin
                alu_out = signed'(data1) + DW_WIDTH'(signed'(imm));
            end
            STORE   : begin
                alu_out = signed'(data1) + DW_WIDTH'(signed'({funct7,rd}));
            end
            default :
        endcase
    end
endmodule
