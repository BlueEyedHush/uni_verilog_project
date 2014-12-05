module multiplexer2_1(
	input [15:0] A,
	input [15:0] B,
	input sel,
	
	output reg [15:0] out
);

always @ (sel or A or B)
begin 
	case(sel)
		0: out[15:0] <= A[15:0];
		1: out[15:0] <= B[15:0];
	endcase
end	

endmodule