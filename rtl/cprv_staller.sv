module cprv_staller (
    input   logic [4:0] rs1_addr_ex,
    input   logic [4:0] rs2_addr_ex,

    input   logic [6:0] opcode_mem,
    input   logic [4:0] rd_addr_mem,

    input   logic valid_ex,
    input   logic ready_ex,

    output  logic valid_ex_o,
    output  logic ready_ex_o
);

    parameter OP        = 7'b01_100_11;
    parameter OP_IMM    = 7'b00_100_11;
    parameter OP_32     = 7'b01_110_11;
    parameter OP_IMM_32 = 7'b00_110_11;
    parameter LOAD      = 7'b00_000_11;
    parameter STORE     = 7'b01_000_11;
    
    always_comb begin
        if(((rs1_addr_ex == rd_addr_mem) || (rs2_addr_ex == rd_addr_mem)) && (opcode_mem == LOAD)) begin
            valid_ex_o = 0;
            ready_ex_o = 0;
        end else begin
            valid_ex_o = valid_ex;
            ready_ex_o = ready_ex;
        end
    end
endmodule
