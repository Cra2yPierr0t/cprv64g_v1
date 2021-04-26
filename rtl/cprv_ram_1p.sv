module cprv_ram_1p #(
    parameter ADDR_WIDTH    = 7,
    parameter DATA_WIDTH    = 64,
)(
    input   logic                  clk,
    input   logic                  w_en,
    input   logic [ADDR_WIDTH-1:0] addr,
    input   logic [DATA_WIDTH-1:0] wdata,
    output  logic [DATA_WIDTH-1:0] rdata
);

    logic [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0];

    always_ff @(posedge clk) begin
        if(w_en) begin
            mem[addr] <= wdata;
            rdata <= wdata;
        end else begin
            rdata <= mem[addr];
        end
    end

endmodule
