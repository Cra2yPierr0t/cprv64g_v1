module cprv_rom_1p_w #(
    parameter ADDR_WIDTH    = 7,
    parameter DATA_WIDTH    = 64
)(
    input   logic                  clk,

    input   logic                  valid_i,
    output  logic                  ready_o,
    input   logic                  w_en,
    input   logic [ADDR_WIDTH-1:0] addr,
    input   logic [DATA_WIDTH-1:0] wdata,
    
    output  logic                  valid_o,
    input   logic                  ready_i,
    output  logic [DATA_WIDTH-1:0] rdata
);

    logic cke = 0;

    logic valid_o_r = 0;
    logic valid_o_rin;

    /*
    cprv_ram_1p #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH)
    ) ram (
        .clk    (clk    ),
        .w_en   (w_en   ),
        .addr   (addr   ),
        .wdata  (wdata  ),
        .rdata  (rdata  )
    );
    */
   assign rdata = 32'b000000000001_00001_000_00001_0010011;
    
    always_comb begin
        if(cke) begin
            valid_o_rin = valid_i; 
        end else begin
            valid_o_rin = valid_o_r;
        end
        valid_o = valid_o_r;
    end
    always_ff @(posedge clk) begin
        valid_o_r <= valid_o_rin;
    end
    always_comb begin
        cke     = ~valid_o | ready_i;
        ready_o = cke;
    end
endmodule
