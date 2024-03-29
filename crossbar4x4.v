module crossbar4x4(
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
  q0      ,  
  q1      ,   
  q2      ,   
  q3      ,
  stall0	,
  stall1	,
  stall2	,
  stall3	,   
  OUT0      ,   
  OUT1      ,   
  OUT2      ,   
  OUT3      );  

parameter ADDRW = 16;
parameter WL = 32;



input clk, ena;
input [ADDRW-1:0] address0, address1, address2, address3;
input [WL-1:0] q0, q1, q2, q3;

output wire stall0, stall1, stall2, stall3;

output [ADDRW-3:0] addressout0, addressout1, addressout2, addressout3;

output [WL-1:0] OUT0,OUT1,OUT2,OUT3;

reg   [WL-1:0] OUT0,OUT1,OUT2,OUT3;


reg [1:0] tmpbanksel0, tmpbanksel1, tmpbanksel2, tmpbanksel3;
reg [1:0] tmp2banksel0, tmp2banksel1, tmp2banksel2, tmp2banksel3;

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


// memory latency one cycle
always @ (posedge clk)
begin
  if(~ena)
    begin
        tmpbanksel0 <= tmpbanksel0;
        tmpbanksel1 <= tmpbanksel1;
        tmpbanksel2 <= tmpbanksel2;
        tmpbanksel3 <= tmpbanksel3;
    end
  else 
    begin
        tmpbanksel0 <= banksel0;
        tmpbanksel1 <= banksel1;
        tmpbanksel2 <= banksel2;
        tmpbanksel3 <= banksel3;
    end
end


always @ (posedge clk)
begin
  if(~ena)
    begin
        tmp2banksel0 <= tmp2banksel0;
        tmp2banksel1 <= tmp2banksel1;
        tmp2banksel2 <= tmp2banksel2;
        tmp2banksel3 <= tmp2banksel3;
    end
  else 
    begin
        tmp2banksel0 <= tmpbanksel0;
        tmp2banksel1 <= tmpbanksel1;
        tmp2banksel2 <= tmpbanksel2;
        tmp2banksel3 <= tmpbanksel3;
    end
end





// get the OUT0
always @ (*) begin
  case (tmp2banksel0)
  2'b00: OUT0 <= q0;
	2'b01: OUT0 <= q1;
	2'b10: OUT0 <= q2;
	2'b11: OUT0 <= q3;
  endcase
end

assign stall0 = 1'b0;



// get the OUT1
always @ (*) begin
  case (tmp2banksel1)
  2'b00: OUT1 <= q0;
	2'b01: OUT1 <= q1;
	2'b10: OUT1 <= q2;
	2'b11: OUT1 <= q3;
  endcase
end

assign stall1 = (tmp2banksel0==tmp2banksel1)? 1'b1: 1'b0;


// get the OUT2
always @ (*) begin
  case (tmp2banksel2)
  2'b00: OUT2 <= q0;
	2'b01: OUT2 <= q1;
	2'b10: OUT2 <= q2;
	2'b11: OUT2 <= q3;
  endcase
end

assign stall2 = ( (tmp2banksel0==tmp2banksel2) || (tmp2banksel1==tmp2banksel2))? 1'b1: 1'b0;

// get the OUT3
always @ (*) begin
  case (tmp2banksel3)
  2'b00: OUT3 <= q0;
	2'b01: OUT3 <= q1;
	2'b10: OUT3 <= q2;
	2'b11: OUT3 <= q3;
  endcase
end

assign stall3 = ( (tmp2banksel0==tmp2banksel3) || (tmp2banksel1==tmp2banksel3) || (tmp2banksel2==tmp2banksel3))? 1'b1: 1'b0;






endmodule
