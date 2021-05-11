module cprv_cpu #(
    parameter DATA_WIDTH = 64
)(
    input   logic                  clk,

    output  logic [DATA_WIDTH-1:0] instr_addr,
    input   logic [DATA_WIDTH-1:0] instr_data,

    output  logic [DATA_WIDTH-1:0] mem_addr,
    output  logic                  mem_w_en,
    output  logic [DATA_WIDTH-1:0] mem_wdata,
    input   logic [DATA_WIDTH-1:0] mem_rdata,
);

    logic [DATA_WIDTH-1:0] instr_addr_r;
    logic [DATA_WIDTH-1:0] instr_addr_rin;

    logic                  valid_if;
    logic                  ready_if;
    logic [31:0]           instr_data_imem;

    logic                  valid_imem;
    logic                  ready_imem;
    logic [ADDR_WIDTH-1:0] instr_addr_imem;

    logic                  valid_id;
    logic                  ready_id;
    logic [31:0]           instr_data_id;

    logic                  valid_ex;
    logic                  ready_ex;
    logic [DATA_WIDTH-1:0] rs1_data_ex;
    logic [DATA_WIDTH-1:0] rs2_data_ex;
    logic [4:0]            rd_addr_ex;
    logic                  rd_en_ex;
    logic [DATA_WIDTH-1:0] imm_data_ex;
    logic [6:0]            opcode_ex;
    logic [2:0]            funct3_ex;
    logic [6:0]            funct7_ex;
    logic                  mem_w_en_ex;

    logic [4:0]            rs1_addr_wb;
    logic [4:0]            rs2_addr_wb;
    logic [DATA_WIDTH-1:0] rs1_data_wb_r;
    logic [DATA_WIDTH-1:0] rs2_data_wb_r;

    logic                  valid_ex;
    logic                  ready_ex;
    logic [DATA_WIDTH-1:0] rs1_data_ex;
    logic [DATA_WIDTH-1:0] rs2_data_ex;
    logic [4:0]            rd_addr_ex;
    logic                  rd_en_ex;
    logic [DATA_WIDTH-1:0] imm_data_ex;
    logic [6:0]            opcode_ex;
    logic [2:0]            funct3_ex;
    logic [2:0]            funct7_ex;
    logic                  mem_w_en_ex;

    logic                  valid_mem;
    logic                  ready_mem;
    logic [DATA_WIDTH-1:0] rs1_data_mem;
    logic [DATA_WIDTH-1:0] rs2_data_mem;
    logic [4:0]            rd_addr_mem;
    logic                  rd_en_mem;
    logic [DATA_WIDTH-1:0] imm_data_mem;
    logic [6:0]            opcode_mem;
    logic [2:0]            funct3_mem;
    logic [2:0]            funct7_mem;
    logic                  mem_w_en_mem;
    logic [DATA_WIDTH-1:0] alu_out_mem;

    logic                  valid_wb;
    logic                  ready_wb;
    logic [DATA_WIDTH-1:0] rs1_data_wb;
    logic [DATA_WIDTH-1:0] rs2_data_wb;
    logic [4:0]            rd_addr_wb;
    logic                  rd_en_wb;
    logic [DATA_WIDTH-1:0] imm_data_wb;
    logic [6:0]            opcode_wb;
    logic [2:0]            funct3_wb;
    logic [2:0]            funct7_wb;
    logic [DATA_WIDTH-1:0] alu_out_wb;
    logic [DATA_WIDTH-1:0] mem_data_wb;

    logic                  valid_mem_dmem;
    logic                  ready_mem_dmem;
    logic [DATA_WIDTH-1:0] rdata_dmem;

    logic                  valid_dmem;
    logic                  ready_dmem;
    logic [ADDR_WIDTH-1:0] addr_dmem;
    logic [DATA_WIDTH-1:0] wdata_dmem;
    logic                  w_en_dmem;

    cprv_if_stage #(
    ) if_stage (
        .clk                (clk            ),
        // data from instr mem
        .valid_if_i         (valid_if       ),
        .ready_if_o         (ready_if       ),
        .instr_data_imem_i  (instr_data_imem),      
        // data to instr mem
        .valid_imem_o       (valid_imem     ),
        .ready_imem_i       (ready_imem     ),
        .instr_addr_imem_o  (instr_addr_imem),
        // data to id stage
        .valid_id_o         (valid_id       ),
        .ready_id_i         (ready_id       ),
        .instr_data_id_o    (instr_data_id  ),
    );

    cprv_id_stage #(
    ) id_stage (
        .clk                (clk            ),
        // data from if stage   
        .valid_id_i         (valid_id       ),
        .ready_id_o         (ready_id       ),
        .instr_data_id_i    (instr_data_id  ),
        // data to ex stage
        .valid_ex_o         (valid_ex       ),
        .ready_ex_i         (ready_ex       ),
        .rs1_data_ex_o      (rs1_data_ex    ),
        .rs2_data_ex_o      (rs2_data_ex    ),
        .rd_addr_ex_o       (rd_addr_ex     ),
        .rd_en_ex_o         (rd_en_ex       ),
        .imm_data_ex_o      (imm_data_ex    ),
        .opcode_ex_o        (opcode_ex      ),
        .funct3_ex_o        (funct3_ex      ),
        .funct7_ex_o        (funct7_ex      ),
        .mem_w_en_ex_o      (mem_w_en_ex    ),
        // data for wb stage
        .rs1_addr_wb_o      (rs1_addr_wb    ),
        .rs2_addr_wb_o      (rs2_addr_wb    ),
        .rs1_data_wb_i      (rs1_data_wb_r  ),
        .rs2_data_wb_i      (rs2_data_wb_r  ),
    );

    cprv_ex_stage #(
    ) ex_stage (
        .clk                (clk            ),
        // data from id stage
        .valid_ex_i         (valid_ex       ),
        .ready_ex_o         (ready_ex       ),
        .rs1_data_ex_i      (rs1_data_ex    ),
        .rs2_data_ex_i      (rs2_data_ex    ),
        .rd_addr_ex_i       (rd_addr_ex     ),
        .rd_en_ex_i         (rd_en_ex       ),
        .imm_data_ex_i      (imm_data_ex    ),
        .opcode_ex_i        (opcode_ex      ),
        .funct3_ex_i        (funct3_ex      ),
        .funct7_ex_i        (funct7_ex      ),
        .mem_w_en_ex_i      (mem_w_en_ex    ),
        // data to mem stage
        .valid_mem_o        (valid_mem      ),
        .ready_mem_i        (ready_mem      ),
        .rs1_data_mem_o     (rs1_data_mem   ),
        .rs2_data_mem_o     (rs2_data_mem   ),
        .rd_addr_mem_o      (rd_addr_mem    ),
        .rd_en_mem_o        (rd_en_mem      ),
        .imm_data_mem_o     (imm_data_mem   ),
        .opcode_mem_o       (opcode_mem     ),
        .funct3_mem_o       (funct3_mem     ),
        .funct7_mem_o       (funct7_mem     ),
        .mem_w_en_mem_o     (mem_w_en_mem   ),
        .alu_out_mem_o      (alu_out_mem    ),
    );

    cprv_mem_stage #(
    ) mem_stage (
        .clk                (clk            ),
        // data from ex stage
        .valid_mem_i        (valid_mem      ),
        .ready_mem_o        (ready_mem      ),
        .rs1_data_mem_i     (rs1_data_mem   ),
        .rs2_data_mem_i     (rs2_data_mem   ),
        .rd_addr_mem_i      (rd_addr_mem    ),
        .rd_en_mem_i        (rd_en_mem      ),
        .imm_data_mem_i     (imm_data_mem   ),
        .opcode_mem_i       (opcode_mem     ),
        .funct3_mem_i       (funct3_mem     ),
        .funct7_mem_i       (funct7_mem     ),
        .mem_w_en_mem_i     (mem_w_en_mem   ),
        .alu_out_mem_i      (alu_out_mem    ),
        // data to wb stage
        .valid_wb_o         (valid_wb       ),
        .ready_wb_i         (ready_wb       ),
        .rs1_data_wb_o      (rs1_data_wb    ),
        .rs2_data_wb_o      (rs2_data_wb    ),
        .rd_addr_wb_o       (rd_addr_wb     ),
        .rd_en_wb_o         (rd_en_wb       ),
        .imm_data_wb_o      (imm_data_wb    ),
        .opcode_wb_o        (opcode_wb      ),
        .funct3_wb_o        (funct3_wb      ),
        .funct7_wb_o        (funct7_wb      ),
        .alu_out_wb_o       (alu_out_wb     ),
        .mem_data_wb_o      (mem_data_wb    ),     
        // data from data mem
        .valid_mem_dmem_i   (valid_mem_dmem ),
        .ready_mem_dmem_o   (ready_mem_dmem ),
        .rdata_dmem_i       (rdata_dmem      ),
        // data to data mem
        .valid_dmem_o       (valid_dmem     ),
        .ready_dmem_i       (ready_dmem     ),
        .addr_dmem_o        (addr_dmem      ),
        .wdata_dmem_o       (wdata_dmem     ),
        .w_en_dmem_o        (w_en_dmem      ),
    );

    cprv_wb_stage #(
    ) wb_stage (
        .clk                (clk            ),
        // data from mem stage
        .valid_wb_i         (valid_wb       ),
        .ready_wb_o         (ready_wb       ),
        .rs1_data_wb_i      (rs1_data_wb    ),
        .rs2_data_wb_i      (rs2_data_wb    ),
        .rd_addr_wb_i       (rd_addr_wb     ),
        .rd_en_wb_i         (rd_en_wb       ),
        .imm_data_wb_i      (imm_data_wb    ),
        .opcode_wb_i        (opcode_wb      ),
        .funct3_wb_i        (funct3_wb      ),
        .funct7_wb_i        (funct7_wb      ),
        .alu_out_wb_i       (alu_out_wb     ),
        .mem_data_wb_i      (mem_data_wb    ),     
        //data for register
        .rs1_addr_wb_i      (rs1_addr_wb    ),
        .rs2_addr_wb_i      (rs2_addr_wb    ),
        .rs1_data_wb_o      (rs1_data_wb_r  ),
        .rs2_data_wb_o      (rs2_data_wb_r  ),
    );

endmodule
