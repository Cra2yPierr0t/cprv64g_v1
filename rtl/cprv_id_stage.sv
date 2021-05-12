module cprv_id_stage #(
    parameter INSTR_WIDTH   = 32,
    parameter DATA_WIDTH    = 64,
    parameter IMM_WIDTH     = 32,
)(
    input   logic                   clk,
    // data from if stage
    input   logic                   valid_id_i,
    output  logic                   ready_id_o,
    input   logic [INSTR_WIDTH-1:0] instr_data_id_i,
    // data to ex stage
    output  logic                   valid_ex_o,
    input   logic                   ready_ex_i,
    output  logic [DATA_WIDTH-1:0]  rs1_data_ex_o,
    output  logic [DATA_WIDTH-1:0]  rs2_data_ex_o,
    output  logic [4:0]             rd_addr_ex_o,
    output  logic                   rd_en_ex_o,
    output  logic [DATA_WIDTH-1:0]  imm_data_ex_o,
    output  logic [6:0]             opcode_ex_o,
    output  logic [2:0]             funct3_ex_o,
    output  logic [6:0]             funct7_ex_o,
    output  logic                   mem_w_en_ex_o,
    // data for wb stage
    output  logic [4:0]             rs1_addr_wb_o,
    output  logic [4:0]             rs2_addr_wb_o,
    output  logic [DATA_WIDTH-1:0]  rs1_data_wb_i,
    output  logic [DATA_WIDTH-1:0]  rs2_data_wb_i,
);

    parameter OP        = 7'b01_100_11;
    parameter OP_IMM    = 7'b00_100_11;
    parameter OP_32     = 7'b01_110_11;
    parameter OP_IMM_32 = 7'b00_110_11;
    parameter LOAD      = 7'b00_000_11;
    parameter STORE     = 7'b01_000_11;

    logic                  cke_ex;
    logic [DATA_WIDTH-1:0] rs1_data_ex_o_r;
    logic [DATA_WIDTH-1:0] rs1_data_ex_o_rin;
    logic [DATA_WIDTH-1:0] rs2_data_ex_o_r;
    logic [DATA_WIDTH-1:0] rs2_data_ex_o_rin;
    logic [4:0]            rd_addr_ex_o_r;
    logic [4:0]            rd_addr_ex_o_rin;
    logic                  rd_en_ex_o_r;
    logic                  rd_en_ex_o_rin;
    
    logic [IMM_WIDTH-1:0]    imm_data_ex_o_r;
    logic [IMM_WIDTH-1:0]    imm_data_ex_o_rin;

    logic                  mem_w_en_ex_o_r;
    logic                  mem_w_en_ex_o_rin;

    logic [6:0]            opcode_ex_o_r;
    logic [6:0]            opcode_ex_o_rin;
    logic [2:0]            funct3_ex_o_r;
    logic [2:0]            funct3_ex_o_rin;
    logic [6:0]            funct7_ex_o_r;
    logic [6:0]            funct7_ex_o_rin;

    always_comb begin
        // for ex stage
        if(cke_ex) begin
            rs1_data_ex_o_rin   = rs1_data_wb_o;
            rs2_data_ex_o_rin   = rs2_data_wb_o;
            rd_addr_ex_o_rin    = instr_data_id_i[11:7];
            case(opcode_ex_o_rin)
                OP          : rd_en_ex_o_rin = 1;
                OP_IMM      : rd_en_ex_o_rin = 1;
                OP_32       : rd_en_ex_o_rin = 1;
                OP_IMM_32   : rd_en_ex_o_rin = 1;
                LOAD        : rd_en_ex_o_rin = 1;
                default     : rd_en_ex_o_rin = 0;
            endcase
            case(opcode_ex_o_rin)
                OP_IMM      : imm_data_ex_o_rin = IMM_WIDTH'(signed'(instr_data_id_i[31:20]));
                OP_IMM_32   : imm_data_ex_o_rin = IMM_WIDTH'(signed'(instr_data_id_i[31:20]));
                LOAD        : imm_data_ex_o_rin = IMM_WIDTH'(signed'(instr_data_id_i[31:20]));
                STORE       : imm_data_ex_o_rin = IMM_WIDTH'(signed'({instr_data_id_i[31:25], instr_data_id_i[11:7]}))
                default     : imm_data_ex_o_rin = '0;
            endcase
            opcode_ex_o_rin     = instr_data_id_i[6:0];
            funct3_ex_o_rin     = instr_data_id_i[14:12];
            funct7_ex_o_rin     = instr_data_id_i[31:25];
            case(opcode_ex_o_rin)
                STORE       : mem_w_en_ex_o_rin = 1;
                default     : mem_w_en_ex_o_rin = 0;
            endcase
        end else begin
            rs1_data_ex_o_rin   = rs1_data_ex_o_r;
            rs2_data_ex_o_rin   = rs2_data_ex_o_r;
            rd_addr_ex_o_rin    = rd_addr_ex_o_r;
            rd_en_ex_o_rin      = rd_en_ex_o_r;
            imm_data_ex_o_rin   = imm_data_ex_o_r;
            opcode_ex_o_rin     = opcode_ex_o_r;
            funct3_ex_o_rin     = funct3_ex_o_r;
            funct7_ex_o_rin     = funct7_ex_o_r;
            mem_w_en_ex_o_rin   = mem_w_en_ex_o_r;
        end
        rs1_data_ex_o   = rs1_data_ex_o_r;
        rs2_data_ex_o   = rs2_data_ex_o_r;
        rd_addr_ex_o    = rd_addr_ex_o_r;
        rd_en_ex_o      = rd_en_ex_o_r;
        imm_data_ex_o   = imm_data_ex_o_r;
        opcode_ex_o     = opcode_ex_o_r;
        funct3_ex_o     = funct3_ex_o_r;
        funct7_ex_o     = funct7_ex_o_r;
        mem_w_en_ex_o   = mem_w_en_ex_r;
        // for wb stage
        rs1_addr_wb_o   = instr_data_id_i[19:15];
        rs2_addr_wb_o   = instr_data_id_i[24:20];
    end
    always_ff @(posedge clk) begin
        valid_ex_o      <= valid_id_i;
        rs1_data_ex_o_r <= rs1_data_ex_o_rin;
        rs2_data_ex_o_r <= rs2_data_ex_o_rin;
        rd_addr_ex_o_r  <= rd_addr_ex_o_rin;
        rd_w_en_ex_o_r  <= rd_w_en_ex_o_rin;
        imm_data_ex_o_r <= imm_data_ex_o_rin;
        opcode_ex_o_r   <= opcode_ex_o_rin;
        funct3_ex_o_r   <= funct3_ex_o_rin;
        funct7_ex_o_r   <= funct7_ex_o_rin;
        mem_w_en_ex_o_r <= mem_en_ex_o_rin;
    end
    always_comb begin
        cke_ex = ~valid_ex_o | ready_ex_i;
        ready_id_o = cke_ex;
    end
endmodule
