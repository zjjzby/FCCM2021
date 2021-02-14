`timescale 1ns/1ns


module tb;

reg clk, ena;

reg [31: 0] value1, value2;
wire [31: 0] ftoutput;


ftadder u0 (
        .clk0   (clk),   //   input,   width = 1,   clk0.clk
        .ena    (ena),    //   input,   width = 1,    ena.ena
        .clr0   (1'b0),   //   input,   width = 1,   clr0.reset
        .result (ftoutput), //  output,  width = 32, result.result
        .ax     (value1),     //   input,  width = 32,     ax.ax
        .ay     (value2)      //   input,  width = 32,     ay.ay
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
   ena = 0;
   value1 = 32'b00111111100000000000000000000000;
   value2 = 32'b00111111100000000000000000000000;

   #35 ena = 1;
   
   #200
   $stop;

end

endmodule