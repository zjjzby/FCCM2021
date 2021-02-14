
module mgfour(
	clk,
	ena, 
	// define memory port
	wrena,
	waddress,
	doublebufferselect,
	data,

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

	//
	outdst0, 
	outdst1, 
	outdst2, 
	outdst3,

	//
	outvalid0, 
	outvalid1, 
	outvalid2, 
	outvalid3,

	//
	outvalue0, 
	outvalue1, 
	outvalue2, 
	outvalue3
);


parameter ADDRW = 16;
parameter WL = 32;


input clk, ena, wrena, doublebufferselect;
input [ADDRW - 1:0] src0, dst0, src1, dst1, src2, dst2, src3, dst3;
input valid0, valid1, valid2, valid3;
input [WL - 1:0] value0, value1, value2, value3, data;

input [ADDRW - 1:0]  waddress;

// define the output
output wire [ADDRW - 1:0] outdst0, outdst1, outdst2, outdst3;
output wire outvalid0, outvalid1, outvalid2, outvalid3;
output wire [WL - 1:0] outvalue0, outvalue1, outvalue2, outvalue3;



// define the interconnection
wire [ADDRW - 1:0] tmpdst0, tmpdst1, tmpdst2, tmpdst3;
wire tmpvalid0, tmpvalid1, tmpvalid2, tmpvalid3;
wire [WL - 1:0] tmpvalue0, tmpvalue1, tmpvalue2, tmpvalue3;

wire tmpstall0, tmpstall1, tmpstall2, tmpstall3;

wire [WL - 1:0] tmpfeature0, tmpfeature1, tmpfeature2, tmpfeature3;

// define wire for memory
wire [ADDRW - 3:0] rdaddress0, rdaddress1, rdaddress2, rdaddress3;


mgpipeline ins0(
	.clk(clk),         // input clk
	.ena(ena),         // input ena
	.stall(tmpstall0),       // input stall
	.src(src0),         // [ADDRW - 1 : 0] input source
	.dst(dst0),         // [ADDRW - 1 : 0] input destination
	.value(value0),       // [WL - 1 : 0] input value
	.valid(valid0),       // input valid
	.feature(tmpfeature0),     // input feature
	.outsrc(srcaddress0),      // [ADDRW - 1 : 0]  output source
	.outdst(tmpdst0),      // [ADDRW - 1 : 0]  output destination
	.outvalid(tmpvalid0),    // ouput valid
	.outvalue(tmpvalue0)     // [WL - 1 : 0] output value
);

mgpipeline ins1(
	.clk(clk),         // input clk
	.ena(ena),         // input ena
	.stall(tmpstall1),       // input stall
	.src(src1),         // [ADDRW - 1 : 0] input source
	.dst(dst1),         // [ADDRW - 1 : 0] input destination
	.value(value1),       // [WL - 1 : 0] input value
	.valid(valid1),       // input valid
	.feature(tmpfeature1),     // input feature
	.outsrc(srcaddress1),      // [ADDRW - 1 : 0]  output source
	.outdst(tmpdst1),      // [ADDRW - 1 : 0]  output destination
	.outvalid(tmpvalid1),    // ouput valid
	.outvalue(tmpvalue1)     // [WL - 1 : 0] output value
);


mgpipeline ins2(
	.clk(clk),         // input clk
	.ena(ena),         // input ena
	.stall(tmpstall2),       // input stall
	.src(src2),         // [ADDRW - 1 : 0] input source
	.dst(dst2),         // [ADDRW - 1 : 0] input destination
	.value(value2),       // [WL - 1 : 0] input value
	.valid(valid2),       // input valid
	.feature(tmpfeature2),     // input feature
	.outsrc(srcaddress2),      // [ADDRW - 1 : 0]  output source
	.outdst(tmpdst2),      // [ADDRW - 1 : 0]  output destination
	.outvalid(tmpvalid2),    // ouput valid
	.outvalue(tmpvalue2)     // [WL - 1 : 0] output value
);


mgpipeline ins3(
	.clk(clk),         // input clk
	.ena(ena),         // input ena
	.stall(tmpstall3),       // input stall
	.src(src3),         // [ADDRW - 1 : 0] input source
	.dst(dst3),         // [ADDRW - 1 : 0] input destination
	.value(value3),       // [WL - 1 : 0] input value
	.valid(valid3),       // input valid
	.feature(tmpfeature3),     // input feature
	.outsrc(srcaddress3),      // [ADDRW - 1 : 0]  output source
	.outdst(tmpdst3),      // [ADDRW - 1 : 0]  output destination
	.outvalid(tmpvalid3),    // ouput valid
	.outvalue(tmpvalue3)     // [WL - 1 : 0] output value
);


// define interconnection
wire [ADDRW - 1:0] srcaddress0, srcaddress1, srcaddress2, srcaddress3;
wire [WL - 1:0] q0, q1, q2, q3;


crossbar4x4 inscrossbar(
	.clk(clk),
	.ena(ena),
	.address0(srcaddress0)		  ,   
	.address1(srcaddress1)       ,   
	.address2(srcaddress2)       ,   
	.address3(srcaddress3)       ,   
	.addressout0(rdaddress0)	,
	.addressout1(rdaddress1)	,
	.addressout2(rdaddress2)	,
	.addressout3(rdaddress3)	,
	.q0(q0)      ,  
	.q1(q1)      ,   
	.q2(q2)      ,   
	.q3(q3)      ,
	.stall0(tmpstall0)	,
	.stall1(tmpstall1)	,
	.stall2(tmpstall2)	,
	.stall3(tmpstall3)	,   
	.OUT0(tmpfeature0)      ,   
	.OUT1(tmpfeature1)      ,   
	.OUT2(tmpfeature2)     ,   
	.OUT3(tmpfeature3)      
);  




sourcebuffer u0 (
	.data      (data),      //   input,  width = 32,      data.datain
	.q         (q0),         //  output,  width = 32,         q.dataout
	.wraddress ({~doublebufferselect, waddress[13:2]}), //   input,  width = 13, wraddress.wraddress
	.rdaddress ({doublebufferselect, rdaddress0[11:0]}), //   input,  width = 13, rdaddress.rdaddress
	.wren      (wrena && (waddress[1:0] == 2'b00)),      //   input,   width = 1,      wren.wren
	.clock     (clk)      //   input,   width = 1,     clock.clk
);

sourcebuffer u1 (
	.data      (data),      //   input,  width = 32,      data.datain
	.q         (q1),         //  output,  width = 32,         q.dataout
	.wraddress ({~doublebufferselect, waddress[13:2]}), //   input,  width = 13, wraddress.wraddress
	.rdaddress ({doublebufferselect, rdaddress1[11:0]}), //   input,  width = 13, rdaddress.rdaddress
	.wren      (wrena && (waddress[1:0] == 2'b01)),      //   input,   width = 1,      wren.wren
	.clock     (clk)      //   input,   width = 1,     clock.clk
);


sourcebuffer u2 (
	.data      (data),      //   input,  width = 32,      data.datain
	.q         (q2),         //  output,  width = 32,         q.dataout
	.wraddress ({~doublebufferselect, waddress[13:2]}), //   input,  width = 13, wraddress.wraddress
	.rdaddress ({doublebufferselect, rdaddress2[11:0]}), //   input,  width = 13, rdaddress.rdaddress
	.wren      (wrena && (waddress[1:0] == 2'b10)),      //   input,   width = 1,      wren.wren
	.clock     (clk)      //   input,   width = 1,     clock.clk
);


sourcebuffer u3 (
	.data      (data),      //   input,  width = 32,      data.datain
	.q         (q3),         //  output,  width = 32,         q.dataout
	.wraddress ({~doublebufferselect, waddress[13:2]}), //   input,  width = 13, wraddress.wraddress
	.rdaddress ({doublebufferselect, rdaddress3[11:0]}), //   input,  width = 13, rdaddress.rdaddress
	.wren      (wrena && (waddress[1:0] == 2'b11)),      //   input,   width = 1,      wren.wren
	.clock     (clk)      //   input,   width = 1,     clock.clk
);




sortAndMerge inssortmerge(
	.clk(clk),
	.ena(ena),
	// input valid port, 1 bit
	.valid1(tmpvalid0),
	.valid2(tmpvalid1),
	.valid3(tmpvalid2),
	.valid4(tmpvalid3),
	// input index port, 16 bit
	.index1(tmpdst0),
	.index2(tmpdst1),
	.index3(tmpdst2),
	.index4(tmpdst3),
	// input value port, 32 bit
	.value1(tmpvalue0),
	.value2(tmpvalue1),
	.value3(tmpvalue2),
	.value4(tmpvalue3),
	// output index port, 16 bit
	.outindex1(outdst0),
	.outindex2(outdst1),
	.outindex3(outdst2),
	.outindex4(outdst3),
	// output value port, 32 bit
	.outvalue1(outvalue0),
	.outvalue2(outvalue1),
	.outvalue3(outvalue2),
	.outvalue4(outvalue3),
	// output valid port, 1 bit
	.outvalid1(outvalid0),
	.outvalid2(outvalid1),
	.outvalid3(outvalid2),
	.outvalid4(outvalid3)
);

endmodule