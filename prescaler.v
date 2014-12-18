module prescaler #(
	parameter DESIRED_FREQ
)(
	input clkin,
	output reg clkout
);

parameter F_OSC = 25175000;
parameter integer CountLimit = F_OSC/DESIRED_FREQ;
parameter integer HalfCountLimit = CountLimit/2;

reg [31:0] counter;

always@(posedge clkin)
	if(counter < HalfCountLimit)
		clkout = 0;
	else
		clkout = 1;

always@(posedge clkin)
	if(counter < CountLimit-1)
		counter <= counter + 1;
	else
		counter <= 0;

endmodule