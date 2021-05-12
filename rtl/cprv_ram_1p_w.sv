module cprv_ram_1p_w #(
)(
    input   logic                  clk,

    input   logic                  valid_i,
    output  logic                  ready_o,
    input   logic                  w_en,
    input   logic [ADDR_WIDTH-1:0] addr,
    input   logic [DATA_WIDTH-1:0] wdata,
    
    output  logic                  valid_o,
    input   logic                  ready_i,
    output  logic [DATA_WIDTH-1:0] rdata,
);

    logic cke;

    logic valid_o_r = 0;
    logic valid_o_rin;

    cprv_ram_1p #(
    ) ram (
        .clk    (clk    ),
        .w_en   (w_en   ),
        .addr   (addr   ),
        .wdata  (wdata  ),
        .rdata  (rdata  )
    );
    
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
