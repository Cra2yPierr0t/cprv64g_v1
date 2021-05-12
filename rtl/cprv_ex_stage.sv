module cprv_ex_stage #(
    parameter DATA_WIDTH    = 64,
    parameter IMM_WIDTH     = 32
)(
    input   logic                   clk,

    input   logic                   valid_ex_i,
    output  logic                   ready_ex_o,
    input   logic [DATA_WIDTH-1:0]  rs1_data_ex_i,
    input   logic [DATA_WIDTH-1:0]  rs2_data_ex_i,
    input   logic [4:0]             rd_addr_ex_i,
    input   logic                   rd_en_ex_i,
    input   logic [IMM_WIDTH-1:0]   imm_data_ex_i,
    input   logic [6:0]             opcode_ex_i,
    input   logic [2:0]             funct3_ex_i,
    input   logic [6:0]             funct7_ex_i,
    input   logic                   mem_w_en_ex_i,

    output  logic                   valid_mem_o,
    input   logic                   ready_mem_i,
    output  logic [DATA_WIDTH-1:0]  rs1_data_mem_o,
    output  logic [DATA_WIDTH-1:0]  rs2_data_mem_o,
    output  logic [4:0]             rd_addr_mem_o,
    output  logic                   rd_en_mem_o,
    output  logic [IMM_WIDTH-1:0]  imm_data_mem_o,
    output  logic [6:0]             opcode_mem_o,
    output  logic [2:0]             funct3_mem_o,
    output  logic [6:0]             funct7_mem_o,
    output  logic                   mem_w_en_mem_o,
    output  logic [DATA_WIDTH-1:0]  alu_out_mem_o
);

    logic cke_mem;

    logic [DATA_WIDTH-1:0]  rs1_data_mem_o_r;
    logic [DATA_WIDTH-1:0]  rs1_data_mem_o_rin;
    logic [DATA_WIDTH-1:0]  rs2_data_mem_o_r;
    logic [DATA_WIDTH-1:0]  rs2_data_mem_o_rin;
    logic [4:0]             rd_addr_mem_o_r;
    logic [4:0]             rd_addr_mem_o_rin;
    logic                   rd_en_mem_o_r;
    logic                   rd_en_mem_o_rin;

    logic [IMM_WIDTH-1:0]    imm_data_mem_o_r;
    logic [IMM_WIDTH-1:0]    imm_data_mem_o_rin;

    logic                  mem_w_en_mem_o_r;
    logic                  mem_w_en_mem_o_rin;

    logic [6:0]            opcode_mem_o_r;
    logic [6:0]            opcode_mem_o_rin;
    logic [2:0]            funct3_mem_o_r;
    logic [2:0]            funct3_mem_o_rin;
    logic [6:0]            funct7_mem_o_r;
    logic [6:0]            funct7_mem_o_rin;

    logic [DATA_WIDTH-1:0]  alu_out;
    logic [DATA_WIDTH-1:0]  alu_out_mem_o_r;
    logic [DATA_WIDTH-1:0]  alu_out_mem_o_rin;

    cprv_alu #(
        .DATA_WIDTH (DATA_WIDTH ),
        .IMM_WIDTH  (IMM_WIDTH  )
    ) alu (
        .opcode (opcode_ex_i    ),
        .funct3 (funct3_ex_i    ),
        .funct7 (funct7_ex_i    ),
        .data1  (rs1_data_ex_i  ),
        .data2  (rs2_data_ex_i  ),
        .imm    (imm_data_ex_i  ),
        .rd     (rd_addr_ex_i   ),
        .alu_out(alu_out        )
    );

    always_comb begin
        if(cke_mem) begin
            alu_out_mem_o_rin   = alu_out;
            rs1_data_mem_o_rin  = rs1_data_ex_i;
            rs2_data_mem_o_rin  = rs2_data_ex_i;
            rd_addr_mem_o_rin   = rd_addr_ex_i;
            rd_en_mem_o_rin     = rd_en_ex_i;
            imm_data_mem_o_rin  = imm_data_ex_i;
            opcode_mem_o_rin    = opcode_ex_i;
            funct3_mem_o_rin    = funct3_ex_i;
            funct7_mem_o_rin    = funct7_ex_i;
            mem_w_en_mem_o_rin  = mem_w_en_ex_i;
        end else begin
            alu_out_mem_o_rin   = alu_out_mem_o_r;
            rs1_data_mem_o_rin  = rs1_data_mem_o_r;
            rs2_data_mem_o_rin  = rs2_data_mem_o_r;
            rd_addr_mem_o_rin   = rd_addr_mem_o_r;
            rd_en_mem_o_rin     = rd_en_mem_o_r;
            imm_data_mem_o_rin  = imm_data_mem_o_r;
            opcode_mem_o_rin    = opcode_mem_o_r;
            funct3_mem_o_rin    = funct3_mem_o_r;
            funct7_mem_o_rin    = funct7_mem_o_r;
            mem_w_en_mem_o_rin  = mem_w_en_mem_o_r;
        end
        rs1_data_mem_o  = rs1_data_mem_o_r;
        rs2_data_mem_o  = rs2_data_mem_o_r;
        rd_addr_mem_o   = rd_addr_mem_o_r;
        rd_en_mem_o     = rd_en_mem_o_r;
        imm_data_mem_o  = imm_data_mem_o_r;
        opcode_mem_o    = opcode_mem_o_r;
        funct3_mem_o    = funct3_mem_o_r;
        funct7_mem_o    = funct7_mem_o_r;
        mem_w_en_mem_o  = mem_w_en_mem_o_r;
        alu_out_mem_o   = alu_out_mem_o_r;
    end
    always_ff @(posedge clk) begin
        valid_mem_o     <= valid_ex_i;
        alu_out_mem_o_r <= alu_out_mem_o_rin;
        rs1_data_mem_o_r<= rs1_data_mem_o_rin;
        rs2_data_mem_o_r<= rs2_data_mem_o_rin;
        rd_addr_mem_o_r <= rd_addr_mem_o_rin;
        rd_en_mem_o_r <= rd_en_mem_o_rin;
        imm_data_mem_o_r<= imm_data_mem_o_rin;
        opcode_mem_o_r  <= opcode_mem_o_rin;
        funct3_mem_o_r  <= funct3_mem_o_rin;
        funct7_mem_o_r  <= funct7_mem_o_rin;
        mem_w_en_mem_o_r<= mem_w_en_mem_o_rin;
    end
    always_comb begin
        cke_mem     = ~valid_mem_o | ready_mem_i;
        ready_ex_o  = cke_mem;
    end
endmodule
