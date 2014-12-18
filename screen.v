module screen16x8diode (
  input wire clk,
  input wire [127:0] data,
  output reg [15:0] columns,
  output reg [7:0] rows
); 

reg [15:0] number;

initial
begin
	number = 1;
	columns = 16'hFFFF;
	rows = 8'hFF;
end

always @(posedge clk)
begin
	if(number >= 128)
	begin
		number <= 1;
		rows <= ~number;
	end else begin
		rows <= ~number;
		number <= number*2;
	end
	
	case(number)
		1   : columns[15:0] <= ~data[127:112];
		2   : columns[15:0] <= ~data[111:96];
		4   : columns[15:0] <= ~data[95:80];
		8   : columns[15:0] <= ~data[79:64];
		16  : columns[15:0] <= ~data[63:48];
		32  : columns[15:0] <= ~data[47:32];
		64  : columns[15:0] <= ~data[31:16];
		128 : columns[15:0] <= ~data[15:0];
	endcase
end
endmodule
