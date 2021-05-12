module cprv_wb_stage #(
    parameter DATA_WIDTH    = 64,
    parameter IMM_WIDTH     = 32
)(
    input   logic                   clk,

    // data from mem stage
    input   logic                   valid_wb_i,
    output  logic                   ready_wb_o,
    input   logic [DATA_WIDTH-1:0]  rs1_data_wb_i,
    input   logic [DATA_WIDTH-1:0]  rs2_data_wb_i,
    input   logic [4:0]             rd_addr_wb_i,
    input   logic                   rd_en_wb_i,
    input   logic [IMM_WIDTH-1:0]   imm_data_wb_i,
    input   logic [6:0]             opcode_wb_i,
    input   logic [2:0]             funct3_wb_i,
    input   logic [6:0]             funct7_wb_i,
    input   logic                   w_en_wb_i,
    input   logic [DATA_WIDTH-1:0]  alu_out_wb_i,
    input   logic [DATA_WIDTH-1:0]  mem_data_wb_i,

    // data to wb stage
    input   logic [4:0]             rs1_addr_wb_i,
    input   logic [4:0]             rs2_addr_wb_i,
    output  logic [DATA_WIDTH-1:0]  rs1_data_wb_o,
    output  logic [DATA_WIDTH-1:0]  rs2_data_wb_o
);
    parameter OP        = 7'b01_100_11;
    parameter LOAD      = 7'b00_000_11;

    logic [DATA_WIDTH-1:0] rd_data;

    always_comb begin
        case(opcode_wb_i) // 適当
            OP      : rd_data   = alu_out_wb_i;
            LOAD    : rd_data   = mem_data_wb_i;
            default : rd_data   = 'hx;
        endcase
    end

    cprv_regfile #(
    ) regfile (
        .clk        (clk            ),
        .rs1_addr   (rs1_addr_wb_i  ),
        .rs2_addr   (rs2_addr_wb_i  ),
        .rd_addr    (rd_addr_wb_i   ),
        .rd_en      (rd_en_wb_i     ),
        .rs1_data   (rs1_data_wb_o  ),
        .rs2_data   (rs2_data_wb_o  ),
        .rd_data    (rd_data        )
    );

    always @(posedge clk) begin
        if(~ready_wb_o) begin
            ready_wb_o <= 1;
        end else if(valid_wb_i) begin
            ready_wb_o <= 0;
        end
    end
endmodule
