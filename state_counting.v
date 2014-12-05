/*
	state no. 0
*/

module state_counting (
	input pause,
	input reset,
	input slowclk,
	input [15:0] initialClockValue,
	input [2:0] currentState,
	
	output [15:0] digitsOut,
	output reg finished
);

parameter stateID = 0;

initial
begin
	paused = 0;
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
	paused = !paused;

always @ (posedge slowclk) 
begin
	if(currentState == stateID && !paused) begin
		if(reset) begin
			min1 <= initialClockValue[15:12];
			min0 <= initialClockValue[11:8];
			sec1 <= initialClockValue[7:4];
			sec0 <= initialClockValue[3:0];
		end
		else begin
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
		end
	end
end

endmodule