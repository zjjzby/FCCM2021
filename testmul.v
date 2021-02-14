`timescale 1ns/1ns


module tb;

reg clk;
reg rst;

reg [31:0] value1, value2;
wire [31:0] q;

multiplier u0 (
        .clk    (clk),    //   input,   width = 1,    clk.clk
        .areset (rst), //   input,   width = 1, areset.reset
        .a      (value1),      //   input,  width = 32,      a.a
        .b      (value2),      //   input,  width = 32,      b.b
        .q      (q)       //  output,  width = 32,      q.q
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
   rst = 1;
   value1 = 32'b00111111100000000000000000000000;
   value2 = 32'b00111111100000000000000000000000;

   #35 rst = 0;
   
   #20;
   value1 = 32'b01000000000000000000000000000000;
   value2 = 32'b01000001010000000000000000000000;
   
   #20; 
   value1 = 32'b01000000100000000000000000000000;
   value2 = 32'b01000000101000000000000000000000;
   
   #20;
   value1 = 32'b01000000101000000000000000000000;
   value2 = 32'b01000000110000000000000000000000;
   
   
   
   #40
   
   $stop;

end



endmodule