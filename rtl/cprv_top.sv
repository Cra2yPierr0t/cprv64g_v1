module cprv_top #(
)(
    input   logic       clk
);

    cprv_cpu #(
        .DATA_WIDTH     (64     ),
        .ADDR_WIDTH     (7      )
    ) cpu (
        .clk            (clk    ),
        .valid_if       (valid_instr_d  ),
        .ready_if       (ready_instr_d  ),
        .instr_data_imem(data_instr_d   ),

        .valid_imem     (valid_instr_a  ),
        .ready_imem     (ready_instr_a  ),
        .instr_addr_imem(addr_instr_a   ),

        .valid_mem_dmem (valid_data_r   ),
        .ready_mem_dmem (ready_data_r   ),
        .rdata_dmem     (data_data_r    ),

        .valid_dmem     (valid_data_w   ),
        .ready_dmem     (ready_data_w   ),
        .addr_dmem      (addr_data_w    ),
        .wdata_dmem     (data_data_w    ),
        .w_en_dmem      (w_en_data_w    )   
    );

    cprv_ram_1p_w #(
        .DATA_WIDTH     (64     ), 
        .ADDR_WIDTH     (7      )
    ) imem (
        .clk        (clk            ),
        .valid_i    (valid_instr_a  ),
        .ready_o    (ready_instr_a  ),
        .w_en       (0              ),
        .addr       (addr_instr_a   ),
        .wdata      (0              ),

        .valid_o    (valid_instr_d  ),
        .ready_i    (ready_instr_d  ),
        .rdata      (data_instr_d   )
    );

    cprv_ram_1p_w #(
        .DATA_WIDTH     (64     ), 
        .ADDR_WIDTH     (7      )
    ) dmem (
        .clk        (clk            ),
        .valid_i    (valid_data_w   ),
        .ready_o    (ready_data_w   ),
        .w_en       (addr_data_w    ),
        .addr       (data_data_w    ),
        .wdata      (w_en_data_w    ),

        .valid_o    (valid_data_r   ),
        .ready_i    (ready_data_r   ),
        .rdata      (data_data_r    )
    );
endmodule
