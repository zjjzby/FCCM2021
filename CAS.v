module CAS(
	clk,
	ena,
	valid1,
	valid2,
	index1,
	index2,
	value1,
	value2,
	outindex1,
	outindex2,
	outvalue1,
	outvalue2,
	outvalid1,
	outvalid2
);


parameter PIPEDEPTH = 5;
parameter ADDRW = 10;
parameter WL = 32;

input clk;
input ena;

input valid1, valid2;

input [ADDRW - 1: 0] index1, index2;
input [WL - 1: 0] value1, value2;


wire [WL - 1: 0]  ftoutput;


output reg outvalid1, outvalid2;

output reg [ADDRW - 1: 0] outindex1, outindex2;

output reg [WL - 1: 0] outvalue1, outvalue2;

reg [WL - 1: 0] tmpvalue1[PIPEDEPTH - 1:0], tmpvalue2[PIPEDEPTH - 1:0];
reg [ADDRW - 1: 0] tmpindex1[PIPEDEPTH - 1:0], tmpindex2[PIPEDEPTH - 1:0];

reg tmpvalid1[PIPEDEPTH - 1:0], tmpvalid2[PIPEDEPTH - 1:0];


ftadder u0 (
        .clk0   (clk),   //   input,   width = 1,   clk0.clk
        .ena    (ena),    //   input,   width = 1,    ena.ena
        .clr0   (1'b0),   //   input,   width = 1,   clr0.reset
        .result (ftoutput), //  output,  width = 32, result.result
        .ax     (value1),     //   input,  width = 32,     ax.ax
        .ay     (tmpvalue2[1])      //   input,  width = 32,     ay.ay
);





always @ (posedge clk)
begin
	if (ena) begin
		case ({valid1, valid2})
		2'b11: begin
					if (index1 == index2)
						begin
							tmpindex1[0] <= index1;
							tmpindex2[0] <= index2;
							tmpvalue1[0] <= value1;
							tmpvalue2[0] <= value2;
						end
					else if (index1 < index2)
						begin
							tmpindex1[0] <= index1;
							tmpindex2[0] <= index2;
							tmpvalue1[0] <= value1;
							tmpvalue2[0] <= value2;
						end
					else
						begin
							tmpindex1[0] <= index2;
							tmpindex2[0] <= index1;
							tmpvalue1[0] <= value2;
							tmpvalue2[0] <= value1;
						end
					tmpvalid1[0] <= 1'b1;
				    tmpvalid2[0] <= 1'b1;
			   end
	    2'b10: begin
	     			tmpindex1[0] <= index1;
					tmpindex2[0] <= index2;
	     			tmpvalid1[0] <= 1'b1;
				    tmpvalid2[0] <= 1'b0;
				    tmpvalue1[0] <= value1;
					tmpvalue2[0] <= value2;
	     	   end
	    2'b01: begin
	    			tmpindex1[0] <= index2;
					tmpindex2[0] <= index2;
					tmpvalid1[0] <= 1'b1;
				    tmpvalid2[0] <= 1'b0;
				    tmpvalue1[0] <= value2;
					tmpvalue2[0] <= value2;
	    	   end
	    2'b00: begin
	    			tmpindex1[0] <= index1;
					tmpindex2[0] <= index2;
					tmpvalid1[0] <= 1'b0;
				    tmpvalid2[0] <= 1'b0;
				    tmpvalue1[0] <= value1;
					tmpvalue2[0] <= value2;
	           end
		endcase
	end
	else begin
		tmpindex1[0] <= tmpindex1[0];
		tmpindex2[0] <= tmpindex2[0];
		tmpvalid1[0] <= tmpvalid1[0];
		tmpvalid2[0] <= tmpvalid2[0];
		tmpvalue1[0] <= tmpvalue1[0];
		tmpvalue2[0] <= tmpvalue2[0];
	end
end



genvar i;
generate

for (i = 1; i < PIPEDEPTH; i = i + 1) begin: indexpropogate
	always @(posedge clk) 
		begin
		if (ena)
			begin
					tmpindex1[i] <= tmpindex1[i - 1];
					tmpindex2[i] <= tmpindex2[i - 1];
					tmpvalue1[i] <= tmpvalue1[i - 1];
					tmpvalue2[i] <= tmpvalue2[i - 1];
					tmpvalid1[i] <= tmpvalid1[i - 1];
					tmpvalid2[i] <= tmpvalid2[i - 1];
			end
		else begin
				
					tmpindex1[i] <= tmpindex1[i];
					tmpindex2[i] <= tmpindex2[i];
					tmpvalue1[i] <= tmpvalue1[i];
					tmpvalue2[i] <= tmpvalue2[i];
					tmpvalid1[i] <= tmpvalid1[i];
					tmpvalid2[i] <= tmpvalid2[i];
		end
	end
end
endgenerate



assign outindex1 = tmpindex1[PIPEDEPTH - 1];
assign outindex2 = tmpindex2[PIPEDEPTH - 1];


always @ (*) begin
	case ({tmpvalid1[PIPEDEPTH - 1], tmpvalid2[PIPEDEPTH - 1]})
	2'b11:begin
		if (tmpindex1[PIPEDEPTH - 1] == tmpindex2[PIPEDEPTH - 1]) begin
			outvalid1 <= 1'b1;
			outvalid2 <= 1'b0;
			outvalue1 <= ftoutput;
			outvalue2 <= ftoutput;
		end
		else begin
			outvalid1 <= 1'b1;
			outvalid2 <= 1'b1;
			outvalue1 <= tmpvalue1[PIPEDEPTH - 1];
			outvalue2 <= tmpvalue2[PIPEDEPTH - 1];			
		end
	end
	2'b10:begin
		outvalid1 <= 1'b1;
		outvalid2 <= 1'b0;
		outvalue1 <= tmpvalue1[PIPEDEPTH - 1];
		outvalue2 <= tmpvalue2[PIPEDEPTH - 1];
	end
	default: begin
		outvalid1 <= 1'b0;
		outvalid2 <= 1'b0;
		outvalue1 <= 32'd0;
		outvalue2 <= 32'd0;
    end	
	endcase
end






endmodule 