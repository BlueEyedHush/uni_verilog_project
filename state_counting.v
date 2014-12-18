/*
	state no. 0
*/

module state_counting (
	input pause,
	input reset,
	input slowclk,
	input clk,
	input [15:0] initialClockValue,
	input [2:0] currentState,
	
	output [15:0] digitsOut,
	output reg finished
);

parameter stateID = 0;

initial
begin
	paused = 0;
	//rAck = 0;
end

// display
reg [3:0] min1;
reg [3:0] min0;
reg [3:0] sec1;
reg [3:0] sec0;
assign digitsOut[15:0] = {min1, min0, sec1, sec0};

// stopping
reg paused;
always @ (posedge pause) 
begin
	if(currentState == stateID)
		paused = !paused;
		
	if(state_changed)
		paused = 0;
end

/*
// reseting
reg resetted;
reg rAck;
always @ (posedge clk)
begin
	if(currentState == stateID) begin
		if(reset == 1) begin
			resetted <= 1;
		end
		else if(rAck == 1) begin
			resetted <= 0;
		end
	end
end
*/

wire state_changed;
sync_edge_detector_3 state_change_detect(
	.in(currentState[2:0]),
	.clk(slowclk),
	.changed(state_changed)
);

always @ (posedge slowclk) 
begin
	if(currentState == stateID /*&& !paused*/) begin
		/*
		jesli w poprzednim cyklu wyslalismy Ack, tutaj je zerujemy
		tamten zegar jest wielokrotnie szybszy od tego, wiec
		z pewnoscia zdazyl juz zauwazyc
		*/
		/*
		if(rAck == 1)
			rAck <= 0;
		*/
		
		if(state_changed) begin
			min1 <=	initialClockValue[15:12];
			min0 <= initialClockValue[11:8];
			sec1 <= initialClockValue[7:4];
			sec0 <= initialClockValue[3:0];
		end 
		/*
		if(resetted || state_changed) begin
			min1 <= initialClockValue[15:12];
			min0 <= initialClockValue[11:8];
			sec1 <= initialClockValue[7:4];
			sec0 <= initialClockValue[3:0];
			rAck <= 1;
		end
		else 
		begin*/
		
		/*
		if(sec0 <= 0) begin
			if(sec1 <= 0) begin
				if(min0 <= 0) begin
					if(min1 <= 0) begin
						finished <= 1;
					end
					else begin
						min1 <= min1 - 1;
						min0 <= 9;
					end 
				end
				else begin
					min0 <= min0 - 1;
					sec1 <= 6;
				end
			end
			else begin
				sec1 <= sec1 - 1;
				sec0 <= 9;
			end
		end
		else begin
			sec0 <= sec0 - 1;
		end
		*/
		
		//end
	end
end

endmodule