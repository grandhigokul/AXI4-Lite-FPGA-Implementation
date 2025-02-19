`timescale 1ns / 1ps

module axi4_lite_top #(
    parameter DATA_WIDTH  = 32,
    parameter ADDRESS_WIDTH = 32
)(
    input logic ACLK,
    input logic ARESETN,
    
    input logic START_READ, 
    input logic START_WRITE
);
    (* DONT_TOUCH = "TRUE" *) logic [31:0] S_RDATA;
    
    logic [31:0] address, W_data;
    logic [31:0] R_data;
    
    logic S_ARREADY, S_RVALID, S_AWREADY, S_WREADY, S_BVALID;
//    logic [31:0] S_RDATA;
    logic [1:0] S_RRESP, S_BRESP;
    logic [31:0] M_ARADDR, M_AWADDR, M_WDATA;
    logic [3:0]  M_WSTRB;
    logic M_ARVALID, M_RREADY, M_AWVALID, M_WVALID, M_BREADY;

//    logic clk_locked;
//    logic clk_gen;
    assign R_data=S_RDATA;

//    clk_wiz_0 clk_wiz(
//        .clk_in1(ACLK),
//        .clk_out1(clk_gen),
//        .reset(ARESETN),
//        .locked(clk_locked)  // Locked signal
//    );
    
    
    
    vio_0 u_vio (
        .clk(ACLK),   
        .probe_out0(address),  
        .probe_out1(W_data),  

        .probe_in0(S_RDATA),      
        .probe_in1(S_BRESP),  
        .probe_in2(S_RRESP)
    );   

    axi4_lite_master master (
        .ACLK(ACLK),
        .ARESETN(ARESETN),
        .START_READ(START_READ),
        .START_WRITE(START_WRITE),
        .address(address),
        .W_data(W_data),
        .M_ARREADY(S_ARREADY),
        .M_RDATA(S_RDATA),
        .M_RRESP(S_RRESP),
        .M_RVALID(S_RVALID),
        .M_AWREADY(S_AWREADY),
        .M_WREADY(S_WREADY),
        .M_BRESP(S_BRESP),
        .M_BVALID(S_BVALID),
        .M_ARADDR(M_ARADDR),
        .M_ARVALID(M_ARVALID),
        .M_RREADY(M_RREADY),
        .M_AWADDR(M_AWADDR),
        .M_AWVALID(M_AWVALID),
        .M_WDATA(M_WDATA),
        .M_WSTRB(M_WSTRB),
        .M_WVALID(M_WVALID),
        .M_BREADY(M_BREADY)
        );

    // AXI4-Lite Slave
    axi4_lite_slave slave (
        .ACLK(ACLK),
        .ARESETN(ARESETN),
        .S_ARADDR(M_ARADDR),
        .S_ARVALID(M_ARVALID),
        .S_RREADY(M_RREADY),
        .S_AWADDR(M_AWADDR),
        .S_AWVALID(M_AWVALID),
        .S_WDATA(M_WDATA),
        .S_WSTRB(M_WSTRB),
        .S_WVALID(M_WVALID),
        .S_BREADY(M_BREADY),
        .S_ARREADY(S_ARREADY),
        .S_RDATA(S_RDATA),
        .S_RRESP(S_RRESP),
        .S_RVALID(S_RVALID),
        .S_AWREADY(S_AWREADY),
        .S_WREADY(S_WREADY),
        .S_BRESP(S_BRESP),
        .S_BVALID(S_BVALID)
    );
    
    ila_0 u_ila (
        .clk(ACLK),              
        .probe0(ARESETN),        
        .probe1(START_WRITE),        
        .probe2(START_READ),         
        .probe3(M_AWADDR),       
        .probe4(M_AWVALID),      
        .probe5(S_AWREADY),      
        .probe6(M_WDATA),        
        .probe7(M_WSTRB),        
        .probe8(M_WVALID),       
        .probe9(S_WREADY),       
        .probe10(S_BRESP),       
        .probe11(S_BVALID),      
        .probe12(M_BREADY),      
        .probe13(M_ARADDR),      
        .probe14(M_ARVALID),     
        .probe15(S_ARREADY),     
        .probe16(R_data),       
        .probe17(S_RRESP),       
        .probe18(S_RVALID),      
        .probe19(M_RREADY)     
    );
    
endmodule