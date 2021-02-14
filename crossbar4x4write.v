module crossbar4x4write(
    clk,
    ena,
  address0       ,   
  address1       ,   
  address2       ,   
  address3       ,   
  addressout0	,
  addressout1	,
  addressout2	,
  addressout3	,
  stall0	,
  stall1	,
  stall2	,
  stall3	 );  

parameter ADDRW = 16;
parameter WL = 32;



input clk, ena;
input [ADDRW-1:0] address0, address1, address2, address3;


output wire stall0, stall1, stall2, stall3;

output [ADDRW-3:0] addressout0, addressout1, addressout2, addressout3;




wire [1:0] banksel0, banksel1, banksel2, banksel3;

assign banksel0 = address0[1:0];
assign banksel1 = address1[1:0];
assign banksel2 = address2[1:0];
assign banksel3 = address3[1:0];


// logic for address assignment

assign addressout0 = (banksel0 == 2'b00)? address0[ADDRW-1:2]: (banksel1 == 2'b00)? address1[ADDRW-1:2] : (banksel2 == 2'b00)? address2[ADDRW-1:2]: address3[ADDRW-1:2];
assign addressout1 = (banksel0 == 2'b01)? address0[ADDRW-1:2]: (banksel1 == 2'b01)? address1[ADDRW-1:2] : (banksel2 == 2'b01)? address2[ADDRW-1:2]: address3[ADDRW-1:2];
assign addressout2 = (banksel0 == 2'b10)? address0[ADDRW-1:2]: (banksel1 == 2'b10)? address1[ADDRW-1:2] : (banksel2 == 2'b10)? address2[ADDRW-1:2]: address3[ADDRW-1:2];
assign addressout3 = (banksel0 == 2'b11)? address0[ADDRW-1:2]: (banksel1 == 2'b11)? address1[ADDRW-1:2] : (banksel2 == 2'b11)? address2[ADDRW-1:2]: address3[ADDRW-1:2];



assign stall0 = 1'b0;

assign stall1 = (banksel0==banksel1)? 1'b1: 1'b0;

assign stall2 = ( (banksel0==banksel2) || (banksel1==banksel2))? 1'b1: 1'b0;

assign stall3 = ( (banksel0==banksel3) || (banksel1==banksel3) || (banksel2==banksel3))? 1'b1: 1'b0;




endmodule
