`timescale 1ns/1ns


module tb;


parameter ADDRW = 10;
parameter WL = 32;


reg clk, ena;

reg valid1, valid2;

reg[ADDRW - 1: 0] index1, index2;

reg[WL - 1: 0] value1, value2;


wire outvalid1, outvalid2;

wire [ADDRW - 1: 0] outindex1, outindex2;

wire [WL - 1: 0] outvalue1, outvalue2;


CAS c0(
	.clk(clk),
	.ena(ena),
	.valid1(valid1),
	.valid2(valid2),
	.index1(index1),
	.index2(index2),
	.value1(value1),
	.value2(value2),
	.outindex1(outindex1),
	.outindex2(outindex2),
	.outvalue1(outvalue1),
	.outvalue2(outvalue2),
	.outvalid1(outvalid1),
	.outvalid2(outvalid2)
);


always 
begin
    clk = 1'b1; 
    #10; // high for 20 * timescale = 20 ns

    clk = 1'b0;
    #10; // low for 20 * timescale = 20 ns
end



initial
begin
   ena = 0;
   valid1 = 1'b1;
   valid2 = 1'b1;
   index1 = 10'b00_0000_0001;
   index2 = 10'b00_0000_0001;
   
   value1 = 32'b00111111100000000000000000000000;
   value2 = 32'b00111111100000000000000000000000;
   
   
   #35 ena = 1;
   
   #20 ;
   index1 = 10'b00_0000_0000;
   index2 = 10'b00_0000_0001;
   
   #20 
   index1 = 10'b00_0000_0001;
   index2 = 10'b00_0000_0000;
   
   #200
   $stop;
   
end


endmodule
