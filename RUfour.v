module RUfour(
	clk,
	ena,
	doublebufferselect, 
	wrena,
	wraddress,
	wdata,

	rdata,
	rraddress,
	
	outstall,
	// input destination
	indst0, 
	indst1, 
	indst2, 
	indst3,

	// input valid
	invalid0, 
	invalid1, 
	invalid2, 
	invalid3,

	//  input value
	invalue0, 
	invalue1, 
	invalue2, 
	invalue3

);


parameter ADDRW = 16;
parameter WL = 32;

// define the input
input clk, ena, wrena, doublebufferselect;
input [ADDRW - 1:0] wraddress, rraddress;
input [WL - 1:0] wdata;
output wire  [WL - 1:0] rdata;
output wire outstall;

wire  [WL - 1:0] rdata0, rdata1, rdata2, rdata3;


input invalid0, invalid1, invalid2, invalid3;
input [ADDRW - 1:0] indst0, indst1, indst2, indst3;
input [WL - 1:0] invalue0, invalue1, invalue2,  invalue3;


// define the wire connection
wire [ADDRW - 1:0] RU2MEMdst0, RU2MEMdst1, RU2MEMdst2, RU2MEMdst3;
wire [WL - 1:0] cross2RU0, cross2RU1, cross2RU2, cross2RU3;
wire cross2RUstall0, cross2RUstall1, cross2RUstall2, cross2RUstall3;


wire [WL - 1:0] db2cross0, db2cross1, db2cross2, db2cross3; 
wire stallwrite0, stallwrite1, stallwrite2, stallwrite3;
wire [WL - 1:0] RU2cross0, RU2cross1, RU2cross2, RU2cross3;

wire [ADDRW - 3:0] addressread0, addressread1, addressread2, addressread3;

wire tmpvalid0, tmpvalid1, tmpvalid2, tmpvalid3;
wire [ADDRW - 1:0] tmpdst0, tmpdst1, tmpdst2, tmpdst3;

wire [ADDRW - 3:0] addresswrite0, addresswrite1, addresswrite2, addresswrite3;


assign rdata = (rraddress[1:0] == 2'b00)? rdata0: (rraddress[1:0] == 2'b01)? rdata1: (rraddress[1:0] == 2'b10)? rdata2: rdata3;

crossbar4x4 readins(
    .clk(clk),
    .ena(ena),
	.address0(RU2MEMdst0)       ,   
	.address1(RU2MEMdst1)      ,   
	.address2(RU2MEMdst2)       ,   
	.address3(RU2MEMdst3)       ,   
	.addressout0(addressread0)	,
	.addressout1(addressread1)	,
	.addressout2(addressread2)	,
	.addressout3(addressread3)	,
	.q0(db2cross0)      ,  
	.q1(db2cross1)      ,   
	.q2(db2cross2)      ,   
	.q3(db2cross3)      ,
	.stall0(cross2RUstall0)	,
	.stall1(cross2RUstall1)	,
	.stall2(cross2RUstall2)	,
	.stall3(cross2RUstall3)	,   
	.OUT0(cross2RU0)      ,   
	.OUT1(cross2RU1)      ,   
	.OUT2(cross2RU2)      ,   
	.OUT3(cross2RU3)      );  


crossbar4x4write writeins(
    .clk(clk),
    .ena(ena),
	.address0(tmpdst0)       ,   
	.address1(tmpdst1)       ,   
	.address2(tmpdst2)       ,   
	.address3(tmpdst3)       ,   
	.addressout0(addresswrite0)	,
	.addressout1(addresswrite1)	,
	.addressout2(addresswrite2)	,
	.addressout3(addresswrite3)	,
	.stall0(stallwrite0)	,
	.stall1(stallwrite1)	,
	.stall2(stallwrite2)	,
	.stall3(stallwrite3)	 );  


destinationbuffer u0 (
	.data_a          (RU2cross0),          //   input,  width = 32,          data_a.datain_a
	.q_a             (db2cross0),             //  output,  width = 32,             q_a.dataout_a
	.data_b          (wdata),          //   input,  width = 32,          data_b.datain_b
	.q_b             (rdata0),             //  output,  width = 32,             q_b.dataout_b
	.write_address_a ({doublebufferselect, addresswrite0[11:0]}), //   input,  width = 13, write_address_a.write_address_a
	.write_address_b ({~doublebufferselect, wraddress[13:2]}), //   input,  width = 13, write_address_b.write_address_b
	.read_address_a  ({doublebufferselect, addressread0[11:0]}),  //   input,  width = 13,  read_address_a.read_address_a
	.read_address_b  ({~doublebufferselect, rraddress[13:2]}),  //   input,  width = 13,  read_address_b.read_address_b
	.wren_a          (tmpvalid0),          //   input,   width = 1,          wren_a.wren_a
	.wren_b          (wrena && (wraddress[1:0] == 2'b00)),          //   input,   width = 1,          wren_b.wren_b
	.clock           (clk)            //   input,   width = 1,           clock.clk
);

destinationbuffer u1 (
	.data_a          (RU2cross1),          //   input,  width = 32,          data_a.datain_a
	.q_a             (db2cross1),             //  output,  width = 32,             q_a.dataout_a
	.data_b          (wdata),          //   input,  width = 32,          data_b.datain_b
	.q_b             (rdata1),             //  output,  width = 32,             q_b.dataout_b
	.write_address_a ({doublebufferselect, addresswrite1[11:0]}), //   input,  width = 13, write_address_a.write_address_a
	.write_address_b ({~doublebufferselect, wraddress[13:2]}), //   input,  width = 13, write_address_b.write_address_b
	.read_address_a  ({doublebufferselect, addressread1[11:0]}),  //   input,  width = 13,  read_address_a.read_address_a
	.read_address_b  ({~doublebufferselect, rraddress[13:2]}),  //   input,  width = 13,  read_address_b.read_address_b
	.wren_a          (tmpvalid1),          //   input,   width = 1,          wren_a.wren_a
	.wren_b          (wrena && (wraddress[1:0] == 2'b01)),          //   input,   width = 1,          wren_b.wren_b
	.clock           (clk)            //   input,   width = 1,           clock.clk
);

destinationbuffer u2 (
	.data_a          (RU2cross2),          //   input,  width = 32,          data_a.datain_a
	.q_a             (db2cross2),             //  output,  width = 32,             q_a.dataout_a
	.data_b          (wdata),          //   input,  width = 32,          data_b.datain_b
	.q_b             (rdata2),             //  output,  width = 32,             q_b.dataout_b
	.write_address_a ({doublebufferselect, addresswrite2[11:0]}), //   input,  width = 13, write_address_a.write_address_a
	.write_address_b ({~doublebufferselect, wraddress[13:2]}), //   input,  width = 13, write_address_b.write_address_b
	.read_address_a  ({doublebufferselect, addressread2[11:0]}),  //   input,  width = 13,  read_address_a.read_address_a
	.read_address_b  ({~doublebufferselect, rraddress[13:2]}),  //   input,  width = 13,  read_address_b.read_address_b
	.wren_a          (tmpvalid2),          //   input,   width = 1,          wren_a.wren_a
	.wren_b          (wrena && (wraddress[1:0] == 2'b10)),          //   input,   width = 1,          wren_b.wren_b
	.clock           (clk)            //   input,   width = 1,           clock.clk
);

destinationbuffer u3 (
	.data_a          (RU2cross3),          //   input,  width = 32,          data_a.datain_a
	.q_a             (db2cross3),             //  output,  width = 32,             q_a.dataout_a
	.data_b          (wdata),          //   input,  width = 32,          data_b.datain_b
	.q_b             (rdata3),             //  output,  width = 32,             q_b.dataout_b
	.write_address_a ({doublebufferselect, addresswrite3[11:0]}), //   input,  width = 13, write_address_a.write_address_a
	.write_address_b ({~doublebufferselect, wraddress[13:2]}), //   input,  width = 13, write_address_b.write_address_b
	.read_address_a  ({doublebufferselect, addressread3[11:0]}),  //   input,  width = 13,  read_address_a.read_address_a
	.read_address_b  ({~doublebufferselect, rraddress[13:2]}),  //   input,  width = 13,  read_address_b.read_address_b
	.wren_a          (tmpvalid3),          //   input,   width = 1,          wren_a.wren_a
	.wren_b          (wrena && (wraddress[1:0] == 2'b11)),          //   input,   width = 1,          wren_b.wren_b
	.clock           (clk)            //   input,   width = 1,           clock.clk
);



RUpipeline RU0(
	.clk(clk),    // input clock
	// input signal
	.ena(ena),    // input ena  
	.stall(cross2RUstall0),   // input stall

	.src(indst0),     
	.value(invalue0),
	.valid(invalid0),

	.feature(cross2RU0),

	.stallwrite(stallwrite0),

	// output signal
	.outsrc(RU2MEMdst0),
	.outvalid(tmpvalid0),
	.outvalue(RU2cross0),
	.outdst(tmpdst0)
);

RUpipeline RU1(
	.clk(clk),    // input clock
	// input signal
	.ena(ena),    // input ena  
	.stall(cross2RUstall1),   // input stall

	.src(indst1),     
	.value(invalue1),
	.valid(invalid1),

	.feature(cross2RU1),

	.stallwrite(stallwrite1),

	// output signal
	.outsrc(RU2MEMdst1),
	.outvalid(tmpvalid1),
	.outvalue(RU2cross1),
	.outdst(tmpdst1)
);

RUpipeline RU2(
	.clk(clk),    // input clock
	// input signal
	.ena(ena),    // input ena  
	.stall(cross2RUstall2),   // input stall

	.src(indst2),     
	.value(invalue2),
	.valid(invalid2),

	.feature(cross2RU2),

	.stallwrite(stallwrite2),

	// output signal
	.outsrc(RU2MEMdst2),
	.outvalid(tmpvalid2),
	.outvalue(RU2cross2),
	.outdst(tmpdst2)
);

RUpipeline RU3(
	.clk(clk),    // input clock
	// input signal
	.ena(ena),    // input ena  
	.stall(cross2RUstall3),   // input stall

	.src(indst3),     
	.value(invalue3),
	.valid(invalid3),

	.feature(cross2RU2),

	.stallwrite(stallwrite3),

	// output signal
	.outsrc(RU2MEMdst3),
	.outvalid(tmpvalid3),
	.outvalue(RU2cross3),
	.outdst(tmpdst3)
);


assign outstall = stallwrite0 || stallwrite1 || stallwrite2 || stallwrite3 || cross2RUstall0 || cross2RUstall1 || cross2RUstall2 || cross2RUstall3;


endmodule