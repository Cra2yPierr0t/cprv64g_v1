module cprv_ram_2p #(
    parameter ADDR_WIDTH    = 7,
    parameter DATA_WIDTH    = 64,
)(
    input   logic                  clk,
    input   logic                  w_en1, w_en2,
    input   logic [ADDR_WIDTH-1:0] addr1, addr2,
    input   logic [DATA_WIDTH-1:0] wdata1, wdata2,
    output  logic [DATA_WIDTH-1:0] rdata1, rdata2 
);

    logic [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0];

    always @(posedge clk) begin
        if(w_en1) begin
            mem[addr1] <= wdata1;
            rdata1 <= wdata1;
        end else begin
            rdata1 <= mem[addr1];
        end
    end

    always @(posedge clk) begin
        if(w_en2) begin
            mem[addr2] <= wdata2;
            rdata2 <= wdata2;
        end else begin
            rdata2 <= mem[addr2];
        end
    end
endmodule
