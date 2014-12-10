module debouncer #(
	parameter REACTION_TIME = 100// in ms
)(
	input button,
	input clk,
	output reg bt_act
);

parameter F_CLK = 25175000;

//automatically calculated, do not modify manually
integer D_TIME = (REACTION_TIME/1000)*F_CLK;

reg [31:0] counter;

always@(posedge clk, negedge button)
	if(button == 0)
		counter <= 0;
	else
		if(counter < D_TIME-1) 
			counter <= counter + 1;
		
always@(posedge clk)
	if(counter < D_TIME/2) bt_act <= 1;
	else bt_act <= 0;

endmodule
