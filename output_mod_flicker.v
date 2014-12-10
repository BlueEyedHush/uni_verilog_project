module output_mod_flicker #(
	parameter FLICKER_FREQ = 0.5
)(
	input [15:0] digits_in,
	input clk,
	input flicker_on,
	
	output reg [15:0] digits_out
);


reg effect_enabled;
always @ flicker_on
	effect_enabled <= flicker_on;

wire flkfreq;
prescaler #(.DESIRED_FREQ(FLICKER_FREQ)) flickfreq (
	.clkin(clk),
	.clkout(flkfreq)
);

reg prv_screen_off;
always @ (posedge flkfreq)
begin
	if(effect_enabled)
	begin
		if(prv_screen_off)
		begin
			digits_out <= digits_in;
			prv_screen_off <= 0;
		end
		else
		begin
			digits_out <= 16'hAAAA;
			prv_screen_off <= 1;
		end
	end
end

endmodule
