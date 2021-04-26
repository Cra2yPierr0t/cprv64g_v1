module cprv_csr #(
    parameter ADDR_WIDTH = 12,
    parameter DATA_WIDTH = 64
)(
    input   logic                  clk,
    input   logic [DATA_WIDTH-1:0] wdata,
    input   logic                  w_en,
    input   logic [ADDR_WIDTH-1:0] addr,
    input   logic [1:0]            priv_mode,
    output  logic [DATA_WIDTH-1:0] rdata
);

    //user mode csr
    //supervisor mode csr

    //machine mode csr
    struct packed {
        logic [1:0]  mxl;
        logic [35:0] wlrl;   
        logic [25:0] Extensions;
    } misa;

    struct packed {
        logic [24:0] Bank;
        logic [7:0]  Offset;
    } mvendorid;

    struct packed {
        logic [63:0] Architecture_ID;
    } marchid;

    struct packed {
        logic [63:0] Implementation;
    } mimpid;

    struct packed {
        logic [63:0] Hard_ID;
    } mhartid;

    typedef struct packed {
        logic        sd;
        logic [26:0] wpri0;
        logic [1:0]  sxl;
        logic [1:0]  uxl;
        logic [8:0]  wpri1;
        logic        tsr;
        logic        tw;
        logic        tvm;
        logic        mxr;
        logic        sum;
        logic        mprv;
        logic [1:0]  xs;
        logic [1:0]  fs;
        logic [1:0]  mpp;
        logic [1:0]  wpri2;
        logic        spp;
        logic        mpie;
        logic        wpri3;
        logic        spie;
        logic        upie;
        logic        mie;
        logic        wpri4;
        logic        sie;
        logic        uie;
    } _status;
    _status mstatus, sstatus, ustatus;
    alias mstatus = sstatus = ustatus;

    typedef struct packed {
        logic [61:0] base;
        logic [1:0]  mode;
    } _tvec;
    _tvec mtvec, stvec, utvec;

    struct packed {
        logic [63:0] Synchronous_Exceptions;
    } medeleg;

    struct packed {
        logic [63:0] Interrupts;
    } mideleg;

    typedef struct packed {
        logic [51:0] wpri0;
        logic        meip;
        logic        wpri1;
        logic        seip;
        logic        ueip;
        logic        mtip;
        logic        wpri2;
        logic        stip;
        logic        utip;
        logic        msip;
        logic        wpri3;
        logic        ssip;
        logic        usip;
    } _ip;
    _ip mip, sip, uip;
    alias mip = sip = uip;

    typedef struct packed {
        logic [51:0] wpri0;
        logic        meie;
        logic        wpri1;
        logic        seie;
        logic        ueie;
        logic        mtie;
        logic        wpri2;
        logic        stie;
        logic        utie;
        logic        msie;
        logic        wpri3;
        logic        ssie;
        logic        usie;
    } _ie;
    _ie mie, sie, uie;
    alias mie = sie = uie;

    logic [63:0] mtime;
    logic [63:0] mtimecmp;

    logic [63:0] mepc;

    struct packed {
        logic        Interrupt;
        logic [62:0] Exception_Code;
    } mcause;

    logic [63:0] mtval, stval, utval;

endmodule
