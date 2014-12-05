module timer_main (
	input button1, // start/stop/start programming/toggle
	input button2, // increaser/reset
	input clk,
	
	output [15:0] digOut
);

reg state;

// slowclk
wire slowclk;
prescaler cs(.clkin(clk), .clkout(slowclk));

wire bt1rise;
wire bt1fall;
sync_edge_detector_1 bt1syncer(
	.in(button1),
	.rise(bt1rise),
	.fall(bt1fall)
);

wire bt2rise;
wire bt2fall;
sync_edge_detector_1 bt2syncer(
	.in(button1),
	.rise(bt2rise),
	.fall(bt2fall)
);

// counter -> programming
reg countdownStarted;
reg stateSwitchCountdown;
wire programmingFinished;

always @ (posedge clk)
begin
	if(state == 0) begin
		if(!countdownStarted && bt1rise) begin
			countdownStarted <= 1;
		end	else 
			if(countdownStarted && bt1fall) begin
				countdownStarted <= 0;
			end
		
		if(countdownStarted && stateSwitchCountdown <= 0) begin
			state <= 1;
			countdownStarted <= 0;
		end
		
		if(programmingFinished)
			state <= 0;
	end
end

always @ (posedge slowclk)
begin
	if(countdownStarted) begin
		if(stateSwitchCountdown > 0)
			stateSwitchCountdown <= stateSwitchCountdown - 1;
		else
			stateSwitchCountdown <= 6;
	end
end

// Above is DONE!

// states
wire [15:0] initClockVal;
assign initClockVal[15:0] = dOutProg [15:0];
wire [15:0] dOutCnt;
wire [15:0] dOutProg;

state_counting cnt(
	.pause(bt1rise), 
	.reset(bt2rise), 
	.slowclk(clk), 
	.initialClockValue(initClockVal), 
	.currentState(state), 
	.digitsOut(dOutCnt), 
	.finished());
	
state_programming(
	.toggle(bt1rise),
	.increase(bt2rise),
	.currentState(state),
	.digitsOut(dOutProg),
	.programmed(programmingFinished));
	
multiplexer2_1 outselect(
	.A(dOutCnt),
	.B(dOutProg),
	.sel(state),
	.out(digOut));
	
endmodule