`timescale 1ns / 1ps
`include "top.sv"

module axi4_lite_tb;

// Parameters
parameter DATA_WIDTH = 32;
parameter ADDRESS_WIDTH = 32;

// Signals
logic ACLK;
logic ARESETN;
logic read_s;
logic write_s;
logic [ADDRESS_WIDTH-1:0] address;
logic [DATA_WIDTH-1:0] W_data;
logic [DATA_WIDTH-1:0] R_data; // Directly access read data from the top module

// Instantiate DUT
axi4_lite_top dut (
    .ACLK(ACLK),
    .ARESETN(ARESETN),
    .read_s(read_s),
    .write_s(write_s),
    .address(address),
    .W_data(W_data),
    .R_data(R_data)  // Directly accessing read data from top module
);

// Clock Generation
always #5 ACLK = ~ACLK; // 10ns clock period

// Task for Reset
task reset_dut;
begin
    ARESETN = 0;
    read_s = 0;
    write_s = 0;
    address = 0;
    W_data = 0;
    #20;
    ARESETN = 1;
end
endtask

// Task for Write Operation
task write_data(input [ADDRESS_WIDTH-1:0] addr, input [DATA_WIDTH-1:0] data);
begin
    @(posedge ACLK);
    address = addr;
    W_data = data;
    write_s = 1;
    @(posedge ACLK);
    write_s = 0;
end
endtask

// Task for Read Operation
task read_data(input [ADDRESS_WIDTH-1:0] addr);
begin
    @(posedge ACLK);
    address = addr;
    read_s = 1;
    @(posedge ACLK);
    read_s = 0;
    @(posedge ACLK); // Wait for valid data
end
endtask

// Main Test Sequence
initial begin
    // Initialize signals
    ACLK = 0;
    reset_dut;
    
    $display("Starting AXI4-Lite Test...");

    // Test Case 1: Simple Write & Read
    write_data(5, 32'hA5A5A5A5);
    #40;
    read_data(5);
    #30
    if (R_data == 32'hA5A5A5A5)
        $display("Test 1 Passed: Write and Read Match!");
    else
        $display("Test 1 Failed: Expected A5A5A5A5, got %h, time=%t", R_data,$time);

    #40;
    // Test Case 2: Writing to Another Address
    write_data(10, 32'h12345678);
    #40;
    read_data(10);
    #30

    if (R_data == 32'h12345678)
        $display("Test 2 Passed: Multiple Addresses Work!");
    else
        $display("Test 2 Failed: Expected 12345678, got %h", R_data);

    #40;
    // Test Case 3: Read from Uninitialized Address
    read_data(15);
 
    #30
    if (R_data == 32'h0)
        $display("Test 3 Passed: Default Register Value is 0!");
    else
        $display("Test 3 Failed: Expected 0, got %h", R_data);

    #40;
    // Test Case 4: Handling Invalid Address (Out of Range)
    write_data(40, 32'hDEADBEEF);
    #40;
    read_data(40);

    #30
    if (R_data == 32'hDEADBEEF)
        $display("Test 4 Failed: Invalid Address Still Written!");
    else
        $display("Test 4 Passed: Invalid Address Not Written!");

    #40;
    // Test Case 5: Consecutive Writes & Reads
    write_data(2, 32'hFFFFFFFF);
    #40;
    write_data(3, 32'h87654321);
    #40;

    read_data(2);

    #30
    if (R_data == 32'hFFFFFFFF)
        $display("Test 5.1 Passed: Consecutive Write 1 Verified!");
    else
        $display("Test 5.1 Failed!");

    #40;
    read_data(3);
 
    #30
    if (R_data == 32'h87654321)
        $display("Test 5.2 Passed: Consecutive Write 2 Verified!");
    else
        $display("Test 5.2 Failed!");

    #40;
    $display("AXI4-Lite Verification Complete!");
    $finish;
end

endmodule
