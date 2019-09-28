`timescale 1ns / 1ps



module Convert_Ascii_to_Music(key_ascii,music_note);//将ascii码转化为对应的音符位置
	input [7:0]key_ascii;
	output reg [4:0] music_note;
	
	
	always @ (*)begin
		case(key_ascii)
			0:music_note=0;
			8'h51:music_note=5'd1;
			8'h57:music_note=5'd2;
			8'h45:music_note=5'd3;
			8'h52:music_note=5'd4;
			8'h54:music_note=5'd5;
			8'h59:music_note=5'd6;
			8'h55:music_note=5'd7;
			8'h41:music_note=5'd8;
			8'h53:music_note=5'd9;
			8'h44:music_note=5'd10;
			8'h46:music_note=5'd11;
			8'h47:music_note=5'd12;
			8'h48:music_note=5'd13;
			8'h4a:music_note=5'd14;
			8'h5a:music_note=5'd15;
			8'h58:music_note=5'd16;
			8'h43:music_note=5'd17;
			8'h56:music_note=5'd18;
			8'h42:music_note=5'd19;
			8'h4e:music_note=5'd20;
			8'h4d:music_note=5'd21;
			default:music_note=0;
			endcase;			
		
	end
	
endmodule
