module cprv_regfile #(
    parameter DATA_WIDTH = 64,
    parameter REGADDR_WIDTH = 5
)(
    input   logic                  clk,
    input   logic [REGADDR_WIDTH-1:0] rs1_addr,
    input   logic [REGADDR_WIDTH-1:0] rs2_addr,
    input   logic [REGADDR_WIDTH-1:0] rd_addr,
    input   logic                   rd_en,

    output  logic [DATA_WIDTH-1:0]  rs1_data,
    output  logic [DATA_WIDTH-1:0]  rs2_data,
    output  logic [DATA_WIDTH-1:0]  rd_data
);

    logic [DATA_WIDTH-1:0] mem [2**REGADDR_WIDTH-1:0];

    always_ff @(posedge clk) begin
        if(rd_en) begin
            mem[rd_addr] <= rd_data;
        end
    end
    // Sorry
    assign rs1_data = (rd_addr == rs1_addr) ? rd_data : mem[rs1_addr];
    assign rs2_data = (rd_addr == rs2_addr) ? rd_data : mem[rs2_addr];

endmodule
