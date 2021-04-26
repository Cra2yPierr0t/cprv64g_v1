module cprv_regfile #(
    parameter DATA_WIDTH = 64,
    parameter ADDR_WIDTH = 5,
    parameter MEM_DEPTH = 2**ADDR_WIDTH
)(
    input   logic                  clk,
    input   logic [ADDR_WIDTH-1:0] rs1_addr,
    input   logic [ADDR_WIDTH-1:0] rs2_addr,
    input   logic [ADDR_WIDTH-1:0] rd_addr,
    input   logic                  rd_en,

    output  logic [DATA_WIDTH-1:0] rs1_data,
    output  logic [DATA_WIDTH-1:0] rs2_data,
    output  logic [DATA_WIDTH-1:0] rd_data,
);

    logic [DATA_WIDTH-1:0] mem [MEM_DEPTH];

    always_ff @(posedge clk) begin
        if(rd_en) begin
            mem[rd_addr] <= rd_data;
        end
    end
    assign rs1_data = mem[rs1_addr];
    assign rs2_data = mem[rs2_addr];

endmodule
