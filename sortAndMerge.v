module sortAndMerge(
	clk,
	ena,
	// input valid port, 1 bit
	valid1,
	valid2,
	valid3,
	valid4,
	// input index port, 16 bit
	index1,
	index2,
	index3,
	index4,
	// input value port, 32 bit
	value1,
	value2,
	value3,
	value4,
	// output index port, 16 bit
	outindex1,
	outindex2,
	outindex3,
	outindex4,
	// output value port, 32 bit
	outvalue1,
	outvalue2,
	outvalue3,
	outvalue4,
	// output valid port, 1 bit
	outvalid1,
	outvalid2,
	outvalid3,
	outvalid4
);

parameter PIPEDEPTH = 5;
parameter ADDRW = 16;
parameter WL = 32;

input clk;
input ena;

input valid1, valid2, valid3, valid4;
input [ADDRW - 1 : 0] index1, index2, index3, index4;
input [WL - 1 : 0] value1, value2, value3, value4;

output wire outvalid1, outvalid2, outvalid3, outvalid4;
output wire [ADDRW - 1 : 0] outindex1, outindex2, outindex3, outindex4;
output wire [WL - 1 : 0] outvalue1, outvalue2, outvalue3, outvalue4;


// define the interconnection between first layer and second layer
wire F2Svalid1, F2Svalid2, F2Svalid3, F2Svalid4;
wire [ADDRW - 1 : 0] F2Sindex1, F2Sindex2, F2Sindex3, F2Sindex4;
wire [WL - 1 : 0] F2Svalue1, F2Svalue2, F2Svalue3, F2Svalue4;

// define the interconnection between second layer and third layer

wire S2Tvalid1, S2Tvalid2, S2Tvalid3, S2Tvalid4;
wire [ADDRW - 1 : 0] S2Tindex1, S2Tindex2, S2Tindex3, S2Tindex4;
wire [WL - 1 : 0] S2Tvalue1, S2Tvalue2, S2Tvalue3, S2Tvalue4;

// first layer:

CAS insfirstlayer1(
	.clk(clk),
	.ena(ena),
	.valid1(valid1),
	.valid2(valid2),
	.index1(index1),
	.index2(index2),
	.value1(value1),
	.value2(value2),
	.outindex1(F2Sindex1),
	.outindex2(F2Sindex2),
	.outvalue1(F2Svalue1),
	.outvalue2(F2Svalue2),
	.outvalid1(F2Svalid1),
	.outvalid2(F2Svalid2)
);

CAS insfirstlayerw(
	.clk(clk),
	.ena(ena),
	.valid1(valid3),
	.valid2(valid4),
	.index1(index3),
	.index2(index4),
	.value1(value3),
	.value2(value4),
	.outindex1(F2Sindex3),
	.outindex2(F2Sindex4),
	.outvalue1(F2Svalue3),
	.outvalue2(F2Svalue4),
	.outvalid1(F2Svalid3),
	.outvalid2(F2Svalid4)
);


// second layer:


CAS inssecondlayer1(
	.clk(clk),
	.ena(ena),
	.valid1(F2Svalid1),
	.valid2(F2Svalid3),
	.index1(F2Sindex1),
	.index2(F2Sindex3),
	.value1(F2Svalue1),
	.value2(F2Svalue3),
	.outindex1(S2Tindex1),
	.outindex2(S2Tindex3),
	.outvalue1(S2Tvalue1),
	.outvalue2(S2Tvalue3),
	.outvalid1(S2Tvalid1),
	.outvalid2(S2Tvalid3)
);

CAS inssecondlayerw(
	.clk(clk),
	.ena(ena),
	.valid1(F2Svalid2),
	.valid2(F2Svalid4),
	.index1(F2Sindex2),
	.index2(F2Sindex4),
	.value1(F2Svalue2),
	.value2(F2Svalue4),
	.outindex1(S2Tindex2),
	.outindex2(S2Tindex4),
	.outvalue1(S2Tvalue2),
	.outvalue2(S2Tvalue4),
	.outvalid1(S2Tvalid2),
	.outvalid2(S2Tvalid4)
);


// third layer

CAS insthirdlayer1(
	.clk(clk),
	.ena(ena),
	.valid1(S2Tvalid1),
	.valid2(S2Tvalid2),
	.index1(S2Tindex1),
	.index2(S2Tindex2),
	.value1(S2Tvalue1),
	.value2(S2Tvalue2),
	.outindex1(outindex1),
	.outindex2(outindex2),
	.outvalue1(outvalue1),
	.outvalue2(outvalue2),
	.outvalid1(outvalid1),
	.outvalid2(outvalid2)
);

CAS insthirdlayerw(
	.clk(clk),
	.ena(ena),
	.valid1(S2Tvalid3),
	.valid2(S2Tvalid4),
	.index1(S2Tindex3),
	.index2(S2Tindex4),
	.value1(S2Tvalue3),
	.value2(S2Tvalue4),
	.outindex1(outindex3),
	.outindex2(outindex4),
	.outvalue1(outvalue3),
	.outvalue2(outvalue4),
	.outvalid1(outvalid3),
	.outvalid2(outvalid4)
);





endmodule