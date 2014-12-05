module screen (
  input wire clk,
  input wire [127:0] data,
  output wire [15:0] columns,
  output wire [7:0] rows
);  
reg number = 0;
reg [7:0] r_columns = 16'hFFFF;
reg [7:0] r_rows = 8'hFF;
assign columns = r_columns;
assign rows = r_rows;
always @(posedge clk)
begin
	if(number > 7)
	begin
		number <= 0;
	end
		case(number)
		0 : r_columns[15:0] <= data[127:112];
		1 : r_columns[15:0] <= data[111:96];
		2 : r_columns[15:0] <= data[95:80];
		3 : r_columns[15:0] <= data[79:64];
		4 : r_columns[15:0] <= data[63:48];
		5 : r_columns[15:0] <= data[47:32];
		6 : r_columns[15:0] <= data[31:16];
		7 : r_columns[15:0] <= data[15:0];
	endcase
	r_rows <= number;
	number <= number + 1;
end
endmodule