module RUpipeline(
	clk,

	// input signal
	ena, 
	stall,

	src,
	value,
	valid,

	feature,

	stallwrite,

	// output signal
	outsrc,
	outvalid,
	outvalue,
	outdst
	
);

parameter PIPEDEPTH = 3;
parameter ADDRW = 16;
parameter WL = 32;
parameter READLATENCY = 1;

input clk,ena;

input valid, stall, stallwrite;
input [ADDRW - 1 : 0] src;
input [WL - 1 : 0] value, feature;

output wire outvalid;
output wire [ADDRW - 1 : 0] outsrc, outdst;
output wire [WL - 1 : 0] outvalue;


assign outsrc = src;


// define tmp register for memory latency
reg [ADDRW - 1 : 0] tmpdst1, tmpdst2;
reg [WL - 1 : 0] tmpvalue1, tmpvalue2;
reg tmpvalid1, tmpvalid2;

always @ (posedge clk)
begin
  if( ~ena || stall || stallwrite)
    begin
		tmpdst1 <= tmpdst1;
		tmpdst2 <= tmpdst2;
		tmpvalue1 <= tmpvalue1;
		tmpvalue2 <= tmpvalue2;
		tmpvalid1 <= tmpvalid1;
		tmpvalid2 <= tmpvalid2;
	end
  else
	begin
		tmpdst1 <= src;
		tmpdst2 <= tmpdst1;
		tmpvalue1 <= value;
		tmpvalue2 <= tmpvalue1;
		tmpvalid1 <= valid;
		tmpvalid2 <= tmpvalid1;
	end
end


// define the tmp register for pipeline latency

reg [ADDRW - 1 : 0] pipdst[PIPEDEPTH - 1:0];
reg pipvalid[PIPEDEPTH - 1:0];

genvar i;
generate

for (i = 1; i < PIPEDEPTH; i = i + 1) begin: validpropogate
	always @(posedge clk) 
	begin
		if(~ena || stall|| stallwrite)
		begin
			pipdst[i] <= pipdst[i];
			pipvalid[i] <= pipvalid[i];
		end
		else	
		begin
			pipdst[i] <= pipdst[i - 1];
			pipvalid[i] <= pipvalid[i - 1];
		end
	end
end
endgenerate

always @(posedge clk)
begin
	if(~ena || stall || stallwrite)
	begin
		pipdst[0] <= pipdst[0];
		pipvalid[0] <= pipvalid[0];
	end
	else 
	begin
		pipdst[0] <= tmpdst2;
		pipvalid[0] <= tmpvalid2;
	end
end


pipadder u0 (
	.clk    (clk),    //   input,   width = 1,    clk.clk
	.areset (1'b0), //   input,   width = 1, areset.reset
	.en     (~ena || stall || stallwrite),     //   input,   width = 1,     en.en
	.a      (feature),      //   input,  width = 32,      a.a
	.b      (tmpvalue2),      //   input,  width = 32,      b.b
	.q      (outvalue)       //  output,  width = 32,      q.q
);


// connect the output
assign outvalid = pipvalid[PIPEDEPTH - 1];
assign outdst = pipvalid[PIPEDEPTH - 1];








endmodule