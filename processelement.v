module processelement(
	clk,
	ena,
	doublebufferselect,
	mgwaddress,
	ruwraddress,
	rurraddress,
	mgdata,
	ruwdata,
	rurdata,
	mgwrena,
	ruwrena,

	// edge input 1
	src0,
	dst0,
	value0,
	valid0,

	// edge input 2
	src1,
	dst1,
	value1,
	valid1,

	// edge input 3
	src2,
	dst2,
	value2,
	valid2,

	// edge input 4
	src3,
	dst3,
	value3,
	valid3,
);

input clk, ena, doublebufferselect;


parameter ADDRW = 16;
parameter WL = 32;

input [ADDRW -1 :0]  src0, src1, src2, src3;

input [ADDRW -1 :0]  dst0, dst1, dst2, dst3;

input [WL -1 :0] value0, value1, value2, value3;

input valid0, valid1, valid2, valid3;

input [ADDRW -1 :0] mgwaddress, ruwraddress, rurraddress;

input [WL -1 :0] mgdata, ruwdata;

output [WL -1 :0] rurdata;

input mgwrena, ruwrena;

wire outstall;


wire [ADDRW - 1:0] outdst0, outdst1, outdst2, outdst3;
wire outvalid0, outvalid1, outvalid2, outvalid3;
wire [WL - 1:0] outvalue0, outvalue1, outvalue2, outvalue3;

mgfour insmg(
	.clk(clk),
	.ena(ena || outstall), 
	// define memory port
	.wrena(mgwrena),
	.waddress(mgwaddress),
	.doublebufferselect(doublebufferselect),
	.data(mgdata),

	// edge input 1
	.src0(src0),
	.dst0(dst0),
	.value0(value0),
	.valid0(valid0),

	// edge input 2
	.src1(src1),
	.dst1(dst1),
	.value1(value1),
	.valid1(valid1),

	// edge input 3
	.src2(src2),
	.dst2(dst2),
	.value2(value2),
	.valid2(valid2),

	// edge input 4
	.src3(src3),
	.dst3(dst3),
	.value3(value3),
	.valid3(valid3),

	//
	.outdst0(outdst0), 
	.outdst1(outdst1), 
	.outdst2(outdst2), 
	.outdst3(outdst3),

	//
	.outvalid0(outvalid0), 
	.outvalid1(outvalid1), 
	.outvalid2(outvalid2), 
	.outvalid3(outvalid3),

	//
	.outvalue0(outvalue0), 
	.outvalue1(outvalue1), 
	.outvalue2(outvalue2), 
	.outvalue3(outvalue3)
);


 
RUfour insru(
	.clk(clk),
	.ena(ena),
	.doublebufferselect(doublebufferselect), 
	.wrena(ruwrena),
	.wraddress(ruwraddress),
	.wdata(ruwdata),

	.rdata(rurdata),
	.rraddress(rurraddress),

	.outstall(outstall),

	// input destination
	.indst0(outdst0), 
	.indst1(outdst1), 
	.indst2(outdst2), 
	.indst3(outdst3),

	// input valid
	.invalid0(outvalid0), 
	.invalid1(outvalid1), 
	.invalid2(outvalid2), 
	.invalid3(outvalid3),

	//  input value
	.invalue0(outvalue0), 
	.invalue1(outvalue1), 
	.invalue2(outvalue2), 
	.invalue3(outvalue3)

);

endmodule