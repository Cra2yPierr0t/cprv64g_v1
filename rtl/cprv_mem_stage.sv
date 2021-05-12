//
// ex -> mem -> wb
//        ^| addr, w_en, wdata
//   rdata|v
//       dmem
//
// store命令なら to dmemのデータ転送完了と from wbのready待ち合わせ
// load命令なら to dmemのデータ転送完了と from dmemのデータ転送完了と from wbのreadyを待ち合わせ

module cprv_mem_stage #( 
    parameter DATA_WIDTH    = 64,
    parameter IMM_WIDTH     = 32
)(
    input   logic                   clk,
    // data from ex stage
    input   logic                   valid_mem_i,
    output  logic                   ready_mem_o,
    input   logic [DATA_WIDTH-1:0]  rs1_data_mem_i,
    input   logic [DATA_WIDTH-1:0]  rs2_data_mem_i,
    input   logic [4:0]             rd_addr_mem_i,
    input   logic                   rd_en_mem_i,
    input   logic [IMM_WIDTH-1:0]   imm_data_mem_i,
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
    output  logic [IMM_WIDTH-1:0]   imm_data_wb_o,
    output  logic [6:0]             opcode_wb_o,
    output  logic [2:0]             funct3_wb_o,
    output  logic [6:0]             funct7_wb_o,
    output  logic                   w_en_wb_o,
    output  logic [DATA_WIDTH-1:0]  alu_out_wb_o,
    output  logic [DATA_WIDTH-1:0]  mem_data_wb_o,
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
    parameter LOAD      = 7'b00_000_11;
    parameter STORE     = 7'b01_000_11;

    logic                   cke_wb;
    logic                   cke_dmem;

    logic [DATA_WIDTH-1:0]  rs1_data_wb_o_r;
    logic [DATA_WIDTH-1:0]  rs1_data_wb_o_rin;
    logic [DATA_WIDTH-1:0]  rs2_data_wb_o_r;
    logic [DATA_WIDTH-1:0]  rs2_data_wb_o_rin;
    logic [4:0]             rd_addr_wb_o_r;
    logic [4:0]             rd_addr_wb_o_rin;
    logic                   rd_en_wb_o_r;
    logic                   rd_en_wb_o_rin;

    logic [IMM_WIDTH-1:0]   imm_data_wb_o_r;
    logic [IMM_WIDTH-1:0]   imm_data_wb_o_rin;

    logic                   w_en_wb_o_r;
    logic                   w_en_wb_o_rin;

    logic [6:0]             opcode_wb_o_r;
    logic [6:0]             opcode_wb_o_rin;
    logic [2:0]             funct3_wb_o_r;
    logic [2:0]             funct3_wb_o_rin;
    logic [6:0]             funct7_wb_o_r;
    logic [6:0]             funct7_wb_o_rin;
    
    logic [DATA_WIDTH-1:0]  alu_out_wb_o_r;
    logic [DATA_WIDTH-1:0]  alu_out_wb_o_rin;

    logic [DATA_WIDTH-1:0]  addr_dmem_o_r;
    logic [DATA_WIDTH-1:0]  addr_dmem_o_rin;
    logic [DATA_WIDTH-1:0]  wdata_dmem_o_r;
    logic [DATA_WIDTH-1:0]  wdata_dmem_o_rin;
    logic [DATA_WIDTH-1:0]  w_en_dmem_o_r;
    logic [DATA_WIDTH-1:0]  w_en_dmem_o_rin;

    logic [DATA_WIDTH-1:0]  mem_data_wb_o_r;
    logic [DATA_WIDTH-1:0]  mem_data_wb_o_rin;

    logic                   valid_wb_o_r;
    logic                   valid_wb_o_rin;

    logic                   valid_dmem_o_r;
    logic                   valid_dmem_o_rin;

    always_comb begin
        if(cke_wb) begin
            case(opcode_mem_i)
                LOAD    : valid_wb_o_rin     = valid_mem_i;
                STORE   : valid_wb_o_rin     = valid_mem_i & valid_mem_dmem_i;
                default : valid_wb_o_rin     = valid_mem_i;
            endcase
            alu_out_wb_o_rin   = alu_out_mem_i;
            rs1_data_wb_o_rin  = rs1_data_mem_i;
            rs2_data_wb_o_rin  = rs2_data_mem_i;
            rd_addr_wb_o_rin   = rd_addr_mem_i;
            rd_en_wb_o_rin     = rd_en_mem_i;
            imm_data_wb_o_rin  = imm_data_mem_i;
            opcode_wb_o_rin    = opcode_mem_i;
            funct3_wb_o_rin    = funct3_mem_i;
            funct7_wb_o_rin    = funct7_mem_i;
            w_en_wb_o_rin      = mem_w_en_mem_i;
            mem_data_wb_o_rin  = rdata_dmem_i;
        end else begin
            valid_wb_o_rin     = valid_wb_o_r;
            alu_out_wb_o_rin   = alu_out_wb_o_r;
            rs1_data_wb_o_rin  = rs1_data_wb_o_r;
            rs2_data_wb_o_rin  = rs2_data_wb_o_r;
            rd_addr_wb_o_rin   = rd_addr_wb_o_r;
            rd_en_wb_o_rin     = rd_en_wb_o_r;
            imm_data_wb_o_rin  = imm_data_wb_o_r;
            opcode_wb_o_rin    = opcode_wb_o_r;
            funct3_wb_o_rin    = funct3_wb_o_r;
            funct7_wb_o_rin    = funct7_wb_o_r;
            w_en_wb_o_rin      = w_en_wb_o_r;
            mem_data_wb_o_rin  = mem_data_wb_o_r;
        end
        if(cke_dmem) begin
            valid_dmem_o_rin   = valid_mem_i;
            addr_dmem_o_rin    = alu_out_mem_i;
            wdata_dmem_o_rin   = rs2_data_mem_i;
            w_en_dmem_o_rin    = mem_w_en_mem_i;
        end else begin
            valid_dmem_o_rin   = valid_dmem_o_r;
            addr_dmem_o_rin    = addr_dmem_o_r;
            wdata_dmem_o_rin   = wdata_dmem_o_r;
            w_en_dmem_o_rin    = w_en_dmem_o_r;
        end
        valid_wb_o      = valid_wb_o_r;
        valid_dmem_o    = valid_dmem_o_r;
        rs1_data_wb_o   = rs1_data_wb_o_r;
        rs2_data_wb_o   = rs2_data_wb_o_r;
        rd_addr_wb_o    = rd_addr_wb_o_r;
        rd_en_wb_o      = rd_en_wb_o_r;
        imm_data_wb_o   = imm_data_wb_o_r;
        opcode_wb_o     = opcode_wb_o_r;
        funct3_wb_o     = funct3_wb_o_r;
        funct7_wb_o     = funct7_wb_o_r;
        w_en_wb_o       = w_en_wb_o_r;
    end
    always_ff @(posedge clk) begin
        valid_wb_o_r    <= valid_wb_o_rin;
        valid_dmem_o_r  <= valid_dmem_o_rin;
        alu_out_wb_o_r  <= alu_out_wb_o_rin;
        rs1_data_wb_o_r <= rs1_data_wb_o_rin;
        rs2_data_wb_o_r <= rs2_data_wb_o_rin;
        rd_addr_wb_o_r  <= rd_addr_wb_o_rin;
        rd_en_wb_o_r    <= rd_en_wb_o_rin;
        imm_data_wb_o_r <= imm_data_wb_o_rin;
        opcode_wb_o_r   <= opcode_wb_o_rin;
        funct3_wb_o_r   <= funct3_wb_o_rin;
        funct7_wb_o_r   <= funct7_wb_o_rin;
        w_en_wb_o_r     <= w_en_wb_o_rin;
        mem_data_wb_o_r <= mem_data_wb_o_rin;
    end
    always_comb begin
        cke_wb          = ~valid_wb_o | ready_wb_i;
        cke_dmem        = ~valid_dmem_o | ready_dmem_i;
        case(opcode_mem_i)
            LOAD    : ready_mem_o = cke_wb & cke_dmem;
            STORE   : ready_mem_o = cke_wb & cke_dmem;
            default : ready_mem_o = cke_wb;
        endcase
        ready_mem_dmem_o = cke_wb;
    end
endmodule
