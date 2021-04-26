module cprv_mem_stage #(
)(
    input   logic                   clk,
    // data from ex stage
    input   logic                   valid_mem_i,
    output  logic                   ready_mem_o,
    input   logic [DATA_WIDTH-1:0]  rs1_data_mem_i,
    input   logic [DATA_WIDTH-1:0]  rs2_data_mem_i,
    input   logic [4:0]             rd_addr_mem_i,
    input   logic                   rd_en_mem_i,
    input   logic [WORD_WIDTH-1:0]  imm_data_mem_i,
    input   logic [6:0]             opcode_mem_i,
    input   logic [2:0]             funct3_mem_i,
    input   logic [6:0]             funct7_mem_i,
    input   logic                   mem_w_en_mem_i,
    input   logic [DATA_WIDTH-1:0]  alu_out_mem_i,
    // data to wb stage
    output  logic                   valid_wb_o,
    input   logic                   ready_wb_i,
    output  logic [DATA_WIDTH-1:0]  rs1_data_wb_o,
    output  logic [DATA_WIDTH-1:0]  rs2_data_wb_o,
    output  logic [4:0]             rd_addr_wb_o,
    output  logic                   rd_en_wb_o,
    output  logic [WORD_WIDTH-1:0]  imm_data_wb_o,
    output  logic [6:0]             opcode_wb_o,
    output  logic [2:0]             funct3_wb_o,
    output  logic [6:0]             funct7_wb_o,
    output  logic                   mem_w_en_wb_o,
    output  logic [DATA_WIDTH-1:0]  alu_out_wb_o,
    // data from data mem
    input   logic                   valid_mem_dmem_i,
    output  logic                   ready_mem_dmem_o,
    input   logic [DATA_WIDTH-1:0]  rdata_dmem_i,
    // data to data mem
    output  logic                   valid_dmem_o,
    input   logic                   ready_dmem_i,
    output  logic [DATA_WIDTH-1:0]  addr_dmem_o,
    output  logic [DATA_WIDTH-1:0]  wdata_dmem_o,
    output  logic                   w_en_dmem_o
);
endmodule
