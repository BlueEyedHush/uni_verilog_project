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
	programmed = 0;
end

wire state_changed;
sync_edge_detector_3 state_change_detect(
	.in(currentState[2:0]),
	.clk(clk),
	.changed(state_changed)
);

// display
reg [7:0] min;
reg [7:0] sec;
assign digitsOut[15:0] = {min, sec};

// toggle
reg currentlyModified; // 0 - seconds, 1 - minutes

always @ (posedge clk)
begin
	if(currentState == stateID) begin
		
		if(state_changed) begin
			min[7:0] <= 8'h00;
			sec[7:0] <= 8'h00;
			programmed <= 1;
		end 
		
		if(toggle) begin
			case(currentlyModified)
				0: currentlyModified <= 1;
				1: programmed <= 1; 
			endcase
		end
		
		begin
			case(currentlyModified)
				0: begin
					if(sec >= 59)
						sec <= 0;
					else
						sec <= sec + 1;
				end
				1: begin
					if(min >= 59)
						min <= 0;
					else
						min <= min + 1;
				end
			endcase
		end
	end
end

endmodule