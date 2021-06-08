module cprv_rom_1p #(
    parameter ADDR_WIDTH    = 7,
    parameter DATA_WIDTH    = 64
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
            mem[addr >> 2] <= wdata;
            rdata <= wdata;
        end else begin
            rdata <= mem[addr >> 2];
        end
    end

    initial begin
        mem[0] = 64'h00100093;  //     	li	ra,1
	    mem[1] = 64'h00108133;  //     	add	sp,ra,ra
   	    mem[2] = 64'h0020b023;  //     	sd	sp,0(ra)
   	    mem[3] = 64'h00000013;  //     	nop
  	    mem[4] = 64'h00000013;  //     	nop
  	    mem[5] = 64'h00000013;  //     	nop
  	    mem[6] = 64'h00000013;  //     	nop
  	    mem[7] = 64'h0000b203;  //     	ld	tp,0(ra)
  	    mem[8] = 64'h00403023;  //     	sd	tp,0(zero) # 0x0
    end

endmodule
