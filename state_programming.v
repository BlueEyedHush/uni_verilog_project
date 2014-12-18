/*
	state no. 1
	to enter that state currentState must change to 1
	state will be exitted when we cycle through both seconds and minutes
*/
module state_programming (
	input [2:0] currentState,
	input toggle, //synchronized
	input increase, //synchronized
	input clk,
	
	output [15:0] digitsOut,
	output reg programmed
);

parameter stateID = 1;

initial begin
	currentlyModified = 0;
	programmed = 0;
	min1 = 4'h0;
	min0 = 4'h0;
	sec1 = 4'h0;
	sec0 = 4'h0;
end

wire state_changed;
sync_edge_detector_3 state_change_detect(
	.in(currentState[2:0]),
	.clk(clk),
	.changed(state_changed)
);

// display
reg [3:0] min1;
reg [3:0] min0;
reg [3:0] sec1;
reg [3:0] sec0;
assign digitsOut[15:0] = {min1, min0, sec1, sec0};

// toggle
reg currentlyModified; // 0 - seconds, 1 - minutes

always @ (posedge clk)
begin
	if(currentState == stateID) begin
		
		if(state_changed) begin
			min1 <= 4'h0;
			min0 <= 4'h0;
			sec1 <= 4'h0;
			sec0 <= 4'h0;
			programmed <= 0;
			currentlyModified <= 0;
		end 
		
		
		if(toggle) begin
			case(currentlyModified)
				0: currentlyModified <= 1;
				1: currentlyModified <= 0;//programmed <= 1; 
			endcase
		end
		
		if(increase) begin
			case(currentlyModified)
				0: begin
					if(sec0 >= 9) begin
						if(sec1 >= 5)
							sec1 <= 0;
						else
							sec1 <= sec1 + 1;
						
						sec0 <= 0;
					end
					else
						sec0 <= sec0 + 1;
				end
				1: begin
					if(min0 >= 9) begin
						if(min1 >= 5)
							min1 <= 0;
						else
							min1 <= min1 + 1;
						
						min0 <= 0;
					end
					else
						min0 <= min0 + 1;
				end
			endcase
		end
	end
end

endmodule