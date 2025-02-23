`timescale 1ns/1ps


module axi4_lite_slave #(
parameter ADDRESS = 32,
parameter DATA_WIDTH = 32
)
(
//Global Signals
input                           ACLK,
input                           ARESETN,

////Read Address Channel INPUTS
input           [ADDRESS-1:0]   S_ARADDR,
input                           S_ARVALID,
//Read Data Channel INPUTS
input                           S_RREADY,
//Write Address Channel INPUTS
input           [ADDRESS-1:0]   S_AWADDR,
input                           S_AWVALID,
//Write Data  Channel INPUTS
input          [DATA_WIDTH-1:0] S_WDATA,
input          [3:0]            S_WSTRB,
input                           S_WVALID,
//Write Response Channel INPUTS
input                           S_BREADY,	

//Read Address Channel OUTPUTS
output logic                    S_ARREADY,
//Read Data Channel OUTPUTS
output logic    [DATA_WIDTH-1:0]S_RDATA,
output logic         [1:0]      S_RRESP,
output logic                    S_RVALID,
//Write Address Channel OUTPUTS
output logic                    S_AWREADY,
output logic                    S_WREADY,
//Write Response Channel OUTPUTS
output logic         [1:0]      S_BRESP,
output logic                    S_BVALID
 );
 
logic [31:0] register[0:31];
logic [31:0]    addr;
//logic  write_addr,write_data;
typedef enum logic [2 : 0] {IDLE,WRITE_CHANNEL,WRESP__CHANNEL, RADDR_CHANNEL, RDATA__CHANNEL} state_type;
state_type state, next_state;

 // AR
assign S_ARREADY = (state == RADDR_CHANNEL) ? 1 : 0;
//// 
assign S_RVALID = (state == RDATA__CHANNEL) ? 1 : 0;
assign S_RDATA  = (state == RDATA__CHANNEL) ? register[addr] : 0;
assign S_RRESP  = (state == RDATA__CHANNEL) ?2'b00:2'b10;
//// AW
assign S_AWREADY = (state == WRITE_CHANNEL) ? 1 : 0;
// W
assign S_WREADY = (state == WRITE_CHANNEL) ? 1 : 0;
//assign write_addr = S_AWVALID && S_AWREADY;
//assign write_data = S_WREADY &&S_WVALID;
// B
assign S_BVALID = (state == WRESP__CHANNEL) ? 1 : 0;
assign S_BRESP  = (state == WRESP__CHANNEL )? 2'b00:2'b10;

integer i;

always_ff @(posedge ACLK) begin
    if (~ARESETN) begin
        // Reset the register array
        for (i = 0; i < 32; i++) begin
            register[i] <= 32'b0;
        end 
    end
    else if (state == RADDR_CHANNEL && S_ARADDR < 32) begin
                addr <= S_ARADDR;
    end
    else begin
                if (state == WRITE_CHANNEL && S_AWADDR < 32) begin
                register[S_AWADDR] <= S_WDATA;
            end
        end
end

always_ff @(posedge ACLK) begin
	if (~ARESETN) begin
		state <= IDLE;
	end else begin
		state <= next_state;
	end
end

always_comb begin
		case (state)
       			IDLE : begin
           			if (S_AWVALID) begin
               				next_state = WRITE_CHANNEL;
           			end else if (S_ARVALID) begin
               				next_state = RADDR_CHANNEL;
           			end else begin
            				next_state = IDLE;
       				end
			end

			RADDR_CHANNEL : next_state = (S_ARVALID && S_ARREADY)? RDATA__CHANNEL:RADDR_CHANNEL;

	   		RDATA__CHANNEL   : next_state = (S_RVALID  && S_RREADY)? IDLE:RDATA__CHANNEL;

       			WRITE_CHANNEL  : next_state = ( S_AWVALID && S_AWREADY && S_WREADY && S_WVALID)? WRESP__CHANNEL:WRITE_CHANNEL;

       			WRESP__CHANNEL  : next_state =(S_BVALID  && S_BREADY )?IDLE:WRESP__CHANNEL;

	   default : next_state = IDLE;
    endcase
end
endmodule

