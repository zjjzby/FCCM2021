module multipleFAM(
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
parameter NUMFAM = 8;

input clk, ena;

input [NUMFAM - 1:0] doublebufferselect, mgwrena, ruwrena;

input [ADDRW*NUMFAM - 1:0] mgwaddress, ruwraddress, rurraddress;


input [WL*NUM*NUMFAM - 1 :0] mgdata, ruwdata;

output [WL*NUM*NUMFAM - 1 :0]  rurdata;

input [ADDRW*NUMFAM -1 :0]  src0, src1, src2, src3;

input [ADDRW*NUMFAM -1 :0]  dst0, dst1, dst2, dst3;

input [WL*NUMFAM -1 :0] value0, value1, value2, value3;

input [NUMFAM - 1:0] valid0, valid1, valid2, valid3;

genvar i;
generate
for (i = 0; i < NUMFAM; i = i + 1) begin: FAMloop
	FAM insfam(
		.clk(clk),
		.ena(ena),
		.doublebufferselect(doublebufferselect[i]),
		.mgwrena(mgwrena[i]),
		.ruwrena(ruwrena[i]),

		.mgwaddress(mgwaddress[ ADDRW*(i+1) - 1: ADDRW*i]),
		.ruwraddress(ruwraddress[ ADDRW*(i+1) - 1: ADDRW*i]), 
		.rurraddress(rurraddress[ ADDRW*(i+1) - 1: ADDRW*i]),

		.mgdata(mgdata[ WL*NUM*(i+1) - 1: WL*NUM*i]),
		.ruwdata(ruwdata[ WL*NUM*(i+1) - 1: WL*NUM*i]),
		.rurdata(rurdata[ WL*NUM*(i+1) - 1: WL*NUM*i]),


		// edge input 1
		.src0(src0[ADDRW*(i+1) -1 :ADDRW*i]),
		.dst0(dst0[ADDRW*(i+1) -1 :ADDRW*i]),
		.value0(value0[WL*(i+1) -1 :WL*i]),
		.valid0(valid0[i]),

		// edge input 2
		.src1(src1[ADDRW*(i+1) -1 :ADDRW*i]),
		.dst1(dst1[ADDRW*(i+1) -1 :ADDRW*i]),
		.value1(value1[WL*(i+1) -1 :WL*i]),
		.valid1(valid1[i]),

		// edge input 3
		.src2(src2[ADDRW*(i+1) -1 :ADDRW*i]),
		.dst2(dst2[ADDRW*(i+1) -1 :ADDRW*i]),
		.value2(value2[WL*(i+1) -1 :WL*i]),
		.valid2(valid2[i]),

		// edge input 4
		.src3(src3[ADDRW*(i+1) -1 :ADDRW*i]),
		.dst3(dst3[ADDRW*(i+1) -1 :ADDRW*i]),
		.value3(value3[WL*(i+1) -1 :WL*i]),
		.valid3(valid3[i])


	);
	end
endgenerate







endmodule