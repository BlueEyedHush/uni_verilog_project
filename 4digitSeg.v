module screen4digitSeg (
	input wire [15:0] data_in,
	output wire [27:0] disp_out
);

dec7seg x1(
	.data_in(data_in[3:0]),
	.seg(disp_out[6:0])
);

dec7seg x2(
	.data_in(data_in[7:4]),
	.seg(disp_out[13:7])
);

dec7seg x3(
	.data_in(data_in[11:8]),
	.seg(disp_out[20:14])
);

dec7seg x4(
	.data_in(data_in[15:12]),
	.seg(disp_out[27:21])
);

endmodule
