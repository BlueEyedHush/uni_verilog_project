module output_mod_flicker (
	input [15:0] digits_in,
	input clk,
	input flicker_on,
	
	output reg [15:0] digits_out
);


reg effect_enabled;
always @ flicker_on
	effect_enabled <= flicker_on;

reg prv_screen_off;
always @ (posedge clk)
begin
	if(effect_enabled)
	begin
		if(prv_screen_off)
		begin
			digits_out <= 16'h0000;
			prv_screen_off <= 0;
		end
		else
		begin
			digits_out <= 8'hAAAA;
			prv_screen_off <= 1;
		end
	end
end

endmodule
