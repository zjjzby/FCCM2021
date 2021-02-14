`timescale 1ns/1ns


module tb;

reg clk, wren;
reg [31:0] data;

wire [31:0] q;

reg [13:0] wraddress, rdaddress;


sourcebuffer u0 (
    .data      (data),      //   input,  width = 32,      data.datain
    .q         (q),         //  output,  width = 32,         q.dataout
    .wraddress (wraddress), //   input,  width = 14, wraddress.wraddress
    .rdaddress (rdaddress), //   input,  width = 14, rdaddress.rdaddress
    .wren      (wren),      //   input,   width = 1,      wren.wren
    .clock     (clk)      //   input,   width = 1,     clock.clk
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
  wren = 1'b0;
  data = 32'd0;
  wraddress = 14'd0;
  rdaddress = 14'd0;
  

  #35;
  wren = 1'b1;
  wraddress = 14'd1;
  data = 32'd23;
  
  #20;
  rdaddress = 14'd1;
  wraddress = 14'd2;
  data = 32'd33;
  
  #20;
  wren = 1'b0;
  rdaddress = 14'd1;
  
  #20;
  rdaddress = 14'd2;

  #200;
  $stop;

end






endmodule