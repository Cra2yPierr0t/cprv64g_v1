module cprv_if_stage #(
    parameter INSTR_WIDTH   = 32,
    parameter DATA_WIDTH    = 64
)(
    input   logic                  clk,
    // data from instr mem
    input   logic                  valid_if_i,
    output  logic                  ready_if_o,
    input   logic [DATA_WIDTH-1:0] instr_data_imem_i,
    // data to instr mem
    output  logic                  valid_imem_o,
    input   logic                  ready_imem_i,
    output  logic [DATA_WIDTH-1:0] instr_addr_imem_o,
    // data to id stage
    output  logic                  valid_id_o,
    input   logic                  ready_id_i,
    output  logic [INSTR_WIDTH-1:0]instr_data_id_o
);

    logic cke;

    logic [INSTR_WIDTH-1:0] instr_addr_r = '0;
    logic [INSTR_WIDTH-1:0] instr_addr_rin;

    // update program counter
    always_comb begin
        if(valid_imem_o & ready_imem_i) begin
            instr_addr_rin  = instr_addr_r + 4;
        end
        instr_addr_imem_o   = instr_addr_r;
    end
    always_ff @(posedge clk) begin
        instr_addr_r <= instr_addr_rin;
        valid_imem_o <= 1;
    end

    // send instruction to id stage
    always_ff @(posedge clk) begin
        if(cke) begin
            valid_id_o      <= valid_if_i;
            instr_data_id_o <= instr_data_imem_i;
        end
    end
    always_comb begin
        cke = ~valid_id_o | ready_id_i;
        ready_if_o = cke;
    end
    
endmodule
