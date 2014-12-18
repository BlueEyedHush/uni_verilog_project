module UP2_TOP
(
	MCLK,
	
	FLEX_DIGIT_1,
	FLEX_DIGIT_1_DP,
	FLEX_DIGIT_2,
	FLEX_DIGIT_2_DP,
	
	FLEX_MOUSE_CLK,
	FLEX_MOUSE_DATA,
	
	VGA_RED,
	VGA_BLUE,
	VGA_GREEN,
	VGA_HSYNC,
	VGA_VSYNC,
	
	LED,
	SW,
	BT,
	
	DISP1,
	DISP1_DP,
	DISP2,
	DISP2_DP,
	DISP3,
	DISP3_DP,
	DISP4,
	DISP4_DP,
	
	PS2_DATA,
	PS2_CLK,
	
	RS232_RX,
	RS232_TX,
	RS232_RTS,
	RS232_CTS,
	
	MATRIX_ROW,
	MATRIX_COL
);

/*
	==== interface description ====
*/

input MCLK;	//main clock input

output [6:0] FLEX_DIGIT_1;
output [6:0] FLEX_DIGIT_2;
output FLEX_DIGIT_1_DP;
output FLEX_DIGIT_2_DP;

output VGA_RED;
output VGA_GREEN;
output VGA_BLUE;
output VGA_HSYNC;
output VGA_VSYNC;

output [15:0] LED;
input [7:0] SW;
input [3:0] BT;

output [6:0] DISP1;
output DISP1_DP;
output [6:0] DISP2;
output DISP2_DP;
output [6:0] DISP3;
output DISP3_DP;
output [6:0] DISP4;
output DISP4_DP;

inout PS2_DATA;
inout PS2_CLK;
inout FLEX_MOUSE_DATA;
inout FLEX_MOUSE_CLK;

input RS232_RX;
output RS232_TX;
output RS232_RTS;
input RS232_CTS;

output [7:0] MATRIX_ROW;
output [15:0] MATRIX_COL;


/*
	==== functionality ====
*/

//let's save some energy
assign FLEX_DIGIT_1[6:0] = 7'b1111111;
assign FLEX_DIGIT_1_DP = 1;
assign FLEX_DIGIT_2[6:0] = 7'b1111111;
assign FLEX_DIGIT_2_DP = 1;
assign DISP1_DP = 1;
assign DISP2_DP = 1;
assign DISP3_DP = 1;
assign DISP4_DP = 1;
//assign LED[15:0] = 16'hFFFF;

wire bt1;
wire bt2;
wire [15:0] disp_data;


/* ToDo
integrate output_mod_flicker
*/
wire bt3;
debouncer stdeb(
	.button(BT[2]),
	.clk(MCLK),
	.bt_act(bt3)
);

wire bt3rise;
wire bt3fall;
sync_edge_detector_1 bt3syncer(
	.in(bt3),
	.clk(MCLK),
	.rise(bt3rise),
	.fall(bt3fall)
);

reg [2:0] st;
assign LED[2:0] = st[2:0];

always @ (posedge MCLK)
begin
	if(bt3rise)
		if(st == 0) 
			st <= 1;
		else 
			st <= 0;
end

timer_main tmain(
	.button1(bt1),
	.button2(bt2),
	.state(st),
	.clk(MCLK),
	.digOut(disp_data[15:0])
);

screen4digitSeg segScreen (
	.data_in(disp_data[15:0]),
	.disp_out({DISP1[6:0], DISP2[6:0], DISP3[6:0], DISP4[6:0]})
);

wire [127:0] screenConnector;
arrayMaker charerizer (
	.currentTime(disp_data[15:0]),
	.data_t(screenConnector[127:0])
);

wire screenClk;
prescaler #(.DESIRED_FREQ(60*8)) refreshClk(
	.clkin(MCLK),
	.clkout(screenClk)
);
screen16x8diode diodeScreen (
	.clk(screenClk),
	.data(screenConnector[127:0]),
	.columns(MATRIX_COL[15:0]),
	.rows(MATRIX_ROW[7:0])
);

debouncer startStop(
	.button(BT[0]),
	.clk(MCLK),
	.bt_act(bt1)
);

debouncer startProgramming(
	.button(BT[1]),
	.clk(MCLK),
	.bt_act(bt2)
);

endmodule

