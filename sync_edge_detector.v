module sync_edge_detector_1(
	input in,
	input clk,
	
	output reg rise,
	output reg fall
);

reg t1;
reg t2;

initial 
begin
	rise <= 0;
	fall <= 0;
end

always @ (posedge clk)
begin
	t2 <= t1;
	t1 <= in;
	
	if(t1 < t2) begin
		rise <= 1;
		fall <= 0;
	end
	else if(t2 > t1) begin
		rise <= 0;
		fall <= 1;
	end
	else begin
		rise <= 0;
		fall <= 0;
	end
end

endmodule

module sync_edge_detector_3(
	input [2:0] in,
	input clk,
	
	output reg changed
);

reg [2:0] t1;
reg [2:0] t2;

initial
begin
	changed <= 0;
end

always @ (posedge clk)
begin
	t2[2:0] <= t1[2:0];
	t1[2:0] <= in[2:0];
	
	if(t1 != t2)
		changed <= 1;
	else 
		changed <= 0;
end

endmodule