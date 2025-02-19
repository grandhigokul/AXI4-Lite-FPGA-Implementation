///*// Code your design here
//`timescale 1ns / 1ps
//`include "master.sv"
//`include "slave.sv"


//module axi4_lite_top#(
//parameter DATA_WIDTH = 32,
//parameter ADDRESS = 32
//)(
//input                           ACLK,
//input                           ARESETN,
//input                           read_s,
//input                           write_s,
//input   [ADDRESS-1:0]           address,
//input   [DATA_WIDTH-1:0]        W_data
//);

//logic  M_ARREADY,S_RVALID,M_ARVALID,M_RREADY,S_AWREADY,S_BVALID,M_AWVALID,M_BREADY,M_WVALID,S_WREADY;
//logic [ADDRESS-1:0]M_ARADDR,M_AWADDR;
//logic [DATA_WIDTH-1:0]M_WDATA,S_RDATA;
//logic [3:0]M_WSTRB;
//logic [1:0]S_RRESP,S_BRESP;

//axi4_lite_master u_axi4_lite_master0
//(
//.ACLK(ACLK),
//.address(address),
//.W_data(W_data),
//.ARESETN(ARESETN),
//.START_READ(read_s),
//.M_ARREADY(M_ARREADY),
//.M_RDATA(S_RDATA),
//.M_RRESP(S_RRESP),
//.M_RVALID(S_RVALID),
//.M_ARADDR(M_ARADDR),
//.M_ARVALID(M_ARVALID),
//.M_RREADY(M_RREADY),
//.START_WRITE(write_s),
//.M_AWREADY(S_AWREADY),
//.M_WVALID(M_WVALID),
//.M_WREADY(S_WREADY),
//.M_BRESP(S_BRESP),
//.M_BVALID(S_BVALID),
//.M_AWADDR(M_AWADDR),
//.M_AWVALID(M_AWVALID),
//.M_WDATA(M_WDATA),
//.M_WSTRB(M_WSTRB),
//.M_BREADY(M_BREADY)
//);

//axi4_lite_slave u_axi4_lite_slave0
//(
//.ACLK(ACLK),
//.ARESETN(ARESETN),
//.S_ARREADY(M_ARREADY),
//.S_RDATA(S_RDATA),
//.S_RRESP(S_RRESP),
//.S_RVALID(S_RVALID),
//.S_ARADDR(M_ARADDR),
//.S_ARVALID(M_ARVALID),
//.S_RREADY(M_RREADY),
//.S_AWREADY(S_AWREADY),
//.S_WVALID(M_WVALID),
//.S_WREADY(S_WREADY),
//.S_BRESP(S_BRESP),
//.S_BVALID(S_BVALID),
//.S_AWADDR(M_AWADDR),
//.S_AWVALID(M_AWVALID),
//.S_WDATA(M_WDATA),
//.S_WSTRB(M_WSTRB),
//.S_BREADY(M_BREADY)
//);
//endmodule*/
`timescale 1ns / 1ps
`include "master.sv"
`include "slave.sv"

module axi4_lite_top #(
    parameter DATA_WIDTH  = 32,
    parameter ADDRESS_WIDTH = 32
)(
    // Clock & Reset
    input                           ACLK,
    input                           ARESETN,

    // Control Inputs
    input                           read_s,
    input                           write_s,
    input   [ADDRESS_WIDTH-1:0]     address,
    input   [DATA_WIDTH-1:0]        W_data,

    // Read Data Output (Added for TB)
    output  [DATA_WIDTH-1:0]        R_data  
);

    // AXI4-Lite Handshake and Data Signals
    logic                            M_ARREADY, S_ARREADY, M_ARVALID, S_ARVALID;
    logic                            M_RREADY, S_RREADY, M_RVALID, S_RVALID;
    logic                            M_AWREADY, S_AWREADY, M_AWVALID, S_AWVALID;
    logic                            M_WREADY, S_WREADY, M_WVALID, S_WVALID;
    logic                            M_BREADY, S_BREADY, M_BVALID, S_BVALID;
    
    logic  [ADDRESS_WIDTH-1:0]       M_ARADDR, S_ARADDR, M_AWADDR, S_AWADDR;
    logic  [DATA_WIDTH-1:0]          M_WDATA, S_WDATA, M_RDATA, S_RDATA;
    logic  [3:0]                     M_WSTRB, S_WSTRB;
    logic  [1:0]                     M_RRESP, S_RRESP, M_BRESP, S_BRESP;

    // Assign Read Data Output (Fix: Exposing Read Data to TB)
    assign R_data = S_RDATA;  // This allows testbench to capture read data

    // Instantiate AXI4-Lite Master
    axi4_lite_master u_axi4_lite_master (
        .ACLK(ACLK),
        .ARESETN(ARESETN),
        
        // Control Signals
        .START_READ(read_s),
        .START_WRITE(write_s),
        .address(address),
        .W_data(W_data),

        // Read Address Channel
        .M_ARADDR(M_ARADDR),
        .M_ARVALID(M_ARVALID),
        .M_ARREADY(M_ARREADY),

        // Read Data Channel
        .M_RDATA(S_RDATA),   // Fix: Connect slave read data to master
        .M_RRESP(S_RRESP),
        .M_RVALID(S_RVALID),
        .M_RREADY(M_RREADY),

        // Write Address Channel
        .M_AWADDR(M_AWADDR),
        .M_AWVALID(M_AWVALID),
        .M_AWREADY(S_AWREADY),

        // Write Data Channel
        .M_WDATA(M_WDATA),
        .M_WSTRB(M_WSTRB),
        .M_WVALID(M_WVALID),
        .M_WREADY(S_WREADY),

        // Write Response Channel
        .M_BRESP(S_BRESP),
        .M_BVALID(S_BVALID),
        .M_BREADY(M_BREADY)
    );

    // Instantiate AXI4-Lite Slave
    axi4_lite_slave u_axi4_lite_slave (
        .ACLK(ACLK),
        .ARESETN(ARESETN),

        // Read Address Channel
        .S_ARADDR(M_ARADDR),
        .S_ARVALID(M_ARVALID),
        .S_ARREADY(M_ARREADY),

        // Read Data Channel
        .S_RDATA(S_RDATA),  // Fix: Ensure S_RDATA is properly assigned
        .S_RRESP(S_RRESP),
        .S_RVALID(S_RVALID),
        .S_RREADY(M_RREADY),

        // Write Address Channel
        .S_AWADDR(M_AWADDR),
        .S_AWVALID(M_AWVALID),
        .S_AWREADY(S_AWREADY),

        // Write Data Channel
        .S_WDATA(M_WDATA),
        .S_WSTRB(M_WSTRB),
        .S_WVALID(M_WVALID),
        .S_WREADY(S_WREADY),

        // Write Response Channel
        .S_BRESP(S_BRESP),
        .S_BVALID(S_BVALID),
        .S_BREADY(M_BREADY)
    );

endmodule  

