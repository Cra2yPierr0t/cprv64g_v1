module cprv_forwarding_mechanism #(
    parameter DATA_WIDTH = 64
)(
    input   logic [4:0]             rs1_addr_ex, 
    input   logic [4:0]             rs2_addr_ex, 
    input   logic [6:0]             opcode_mem,
    input   logic [4:0]             rd_addr_mem, 
    input   logic                   rd_en_mem,
    input   logic [6:0]             opcode_wb,
    input   logic [4:0]             rd_addr_wb, 
    input   logic                   rd_en_wb,
    input   logic [DATA_WIDTH-1:0]  rs1_data_id_ex,
    input   logic [DATA_WIDTH-1:0]  rs2_data_id_ex,
    input   logic [DATA_WIDTH-1:0]  alu_out_mem,
    input   logic [DATA_WIDTH-1:0]  alu_out_wb,
    input   logic [DATA_WIDTH-1:0]  mem_data_wb,
    output  logic [DATA_WIDTH-1:0]  rs1_data_ex,
    output  logic [DATA_WIDTH-1:0]  rs2_data_ex
);
    parameter OP        = 7'b01_100_11;
    parameter OP_IMM    = 7'b00_100_11;
    parameter OP_32     = 7'b01_110_11;
    parameter OP_IMM_32 = 7'b00_110_11;
    parameter LOAD      = 7'b00_000_11;

    logic fwd_from_mem1;
    logic fwd_from_mem2;
    logic fwd_from_wb1;
    logic fwd_from_wb2;

    always_comb begin
        if((rd_en_mem == 1) && (rs1_addr_ex == rd_addr_mem)) begin
            rs1_data_ex = alu_out_mem;
            fwd_from_mem1 = 1;
            fwd_from_wb1 = 0;
        end else if((rd_en_wb == 1) && (rs1_addr_ex == rd_addr_wb) && (opcode_wb == LOAD)) begin
            rs1_data_ex = mem_data_wb;
            fwd_from_mem1 = 0;
            fwd_from_wb1 = 1;
        end else if((rd_en_wb == 1) && (rs1_addr_ex == rd_addr_wb)) begin
            rs1_data_ex = alu_out_wb;
            fwd_from_mem1 = 0;
            fwd_from_wb1 = 1;
        end else begin
            rs1_data_ex = rs1_data_id_ex;
            fwd_from_mem1 = 0;
            fwd_from_wb1 = 0;
        end

        if((rd_en_mem == 1) && (rs2_addr_ex == rd_addr_mem)) begin
            rs2_data_ex = alu_out_mem;
            fwd_from_mem2 = 1;
            fwd_from_wb2 = 0;
        end else if((rd_en_wb == 1) && (rs2_addr_ex == rd_addr_wb) && (opcode_wb == LOAD)) begin
            rs2_data_ex = mem_data_wb;
            fwd_from_mem2 = 0;
            fwd_from_wb2 = 1;
        end else if((rd_en_wb == 1) && (rs2_addr_ex == rd_addr_wb)) begin
            rs2_data_ex = alu_out_wb;
            fwd_from_mem2 = 0;
            fwd_from_wb2 = 1;
        end else begin
            rs2_data_ex = rs2_data_id_ex;
            fwd_from_mem2 = 0;
            fwd_from_wb2 = 0;
        end
    end
endmodule
