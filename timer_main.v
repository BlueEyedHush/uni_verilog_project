module timer_main (
	input button1, // start/stop/start programming/toggle
	input button2, // increaser/reset
	input state,
	input clk,
	
	output [15:0] digOut
);

parameter ST_CH_AFT = 5;

//reg state;

// slowclk
wire slowclk;
prescaler #(.DESIRED_FREQ(1)) cs(
	.clkin(clk), 
	.clkout(slowclk)
);

wire bt1rise;
wire bt1fall;
sync_edge_detector_1 bt1syncer(
	.in(button1),
	.clk(clk),
	.rise(bt1rise),
	.fall(bt1fall)
);

wire bt2rise;
wire bt2fall;
sync_edge_detector_1 bt2syncer(
	.in(button2),
	.clk(clk),
	.rise(bt2rise),
	.fall(bt2fall)
);

// counter -> programming
reg countdownStarted;
reg [31:0] stateSwitchCountdown;
wire programmingFinished;

/*
always @ (posedge clk)
begin
	if(state == 0) begin
		if(!countdownStarted && bt1rise) begin
			countdownStarted <= 1;
		end	else 
			if(countdownStarted && bt1fall) begin
				countdownStarted <= 0;
			end
		
		if(countdownStarted && stateSwitchCountdown <= 1) begin
			state <= 1;
			countdownStarted <= 0;
		end
	end
	
	if(state == 1) begin
		if(programmingFinished)
			state <= 0;
	end
end
*/

/*
always @ (posedge slowclk)
begin
	if(countdownStarted) begin
		if(stateSwitchCountdown > 0)
			stateSwitchCountdown <= stateSwitchCountdown - 1;
		else
			stateSwitchCountdown <= ST_CH_AFT+1;
	end
end
*/

// states
wire [15:0] dOutCnt;
wire [15:0] dOutProg;
wire [15:0] toFlicker;


state_counting cnt(
	.pause(bt1rise), 
	.reset(bt2rise), 
	.slowclk(slowclk),
	.clk(clk), 
	.initialClockValue(dOutProg), 
	.currentState(state), 
	.digitsOut(dOutCnt), 
	.finished());

state_programming stt(
	.toggle(bt1rise),
	.increase(bt2rise),
	.currentState(state),
	.clk(clk),
	.digitsOut(dOutProg),
	.programmed()
	//.programmed(programmingFinished)
);
	
multiplexer2_1 outselect(
	.A(dOutCnt),
	.B(dOutProg),
	.sel(state),
	.out(digOut)
	//.out(toFlicker)
);
/*	
output_mod_flicker flicker(
	.digits_in(toFlicker),
	.clk(clk),
	.flicker_on(state),
	
	.digits_out(digOut)
);
*/
endmodule