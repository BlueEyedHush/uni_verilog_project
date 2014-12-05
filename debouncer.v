module debouncer (
	input button,
	input clk,
	output reg bt_act
);

parameter F_CLK = 25175000;
parameter REACTION_TIME = 100;// in ms

//automatically calculated, do not modify manually
parameter D_TIME = REACTION_TIME*F_CLK/1000;

reg [31:0] counter;

always@(posedge clk, negedge button)
	if(button == 0)
	counter <= 0;
	else
		if( counter < D_TIME ) counter <= counter + 1;
		
always@(posedge clk)
	if(counter < D_TIME) bt_act <= 1;
	else bt_act <= 0;

endmodule
