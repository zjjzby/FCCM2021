module FAM(
	clk,
	ena,
	doublebufferselect,
	mgwrena,
	ruwrena,

	mgwaddress,
	ruwraddress, 
	rurraddress,

	mgdata,
	ruwdata,
	rurdata,


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

parameter ADDRW = 16;
parameter WL = 32;
parameter NUM = 16;

input clk, ena, doublebufferselect, mgwrena, ruwrena;

input [ADDRW - 1:0] mgwaddress, ruwraddress, rurraddress;


//input [WL*NUM - 1 :0] mgdata, ruwdata;
input [WL - 1 :0] mgdata, ruwdata;
//output [WL*NUM - 1 :0]  rurdata;
output [WL*NUM  - 1 :0]  rurdata;

input [ADDRW -1 :0]  src0, src1, src2, src3;

input [ADDRW -1 :0]  dst0, dst1, dst2, dst3;

input [WL -1 :0] value0, value1, value2, value3;

input valid0, valid1, valid2, valid3;



genvar i;
generate

for (i = 0; i < NUM; i = i + 1) begin: PE
		processelement ins(
			.clk(clk),
			.ena(ena),
			.doublebufferselect(doublebufferselect),
			.mgwaddress(mgwaddress),
			.ruwraddress(ruwraddress),
			.rurraddress(rurraddress),
			.mgdata(mgdata),
			.ruwdata(ruwdata),
			.rurdata(rurdata[ (i + 1) * WL - 1: i*WL ]),
			.mgwrena(mgwrena),
			.ruwrena(ruwrena),

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
			.valid3(valid3)
		);	
end
endgenerate

endmodule