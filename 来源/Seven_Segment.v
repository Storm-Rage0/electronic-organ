`timescale 1ns / 1ps

//七段数码管输出
module Seven_Segment(
	input [4:0] music,
	input [1:0]rotation,
	input reset,//高电平有效
	input clk,
    output reg [7:0] Choose,
    output reg [6:0] oData
    );
	
	wire clk_1khz;
	reg [3:0]iData;
	reg [1:0] cnt=0;
	
	Divider_1KHZ(clk,0,clk_1khz);
	
	always @ (posedge clk_1khz or posedge reset or negedge music)begin
	if(reset==1||music==0||music>=22)begin
		oData<=7'b1111111;
		Choose<=8'b11111111;
	end
	else begin
		if(cnt==0)begin//升降记号
			oData<=0;
			cnt<=cnt+1;
			Choose<=8'b11101111;
			case(rotation)
				0:oData<=7'b0111111;
				1:oData<=7'b1110111;
				2:oData<=7'b1111110;
				default:oData<=7'b1111111;
			endcase
			if((music==5'd1||music==5'd4||music==5'd8||music==5'd11||music==5'd15||music==5'd18)&&rotation==1)//1 4没有降音
				oData<=7'b0111111;
			else if((music==5'd3||music==5'd7||music==5'd10||music==5'd14||music==5'd17||music==5'd21)&&rotation==2)//3 7没有升音
				oData<=7'b0111111;
		end
		else if(cnt==1)begin//高中低音记号
			oData<=0;
			cnt<=cnt+1;
			Choose<=8'b11110111;
			if(music>=15&&music<=21)
				oData<=7'b1111110;
			else if(music>=1&&music<=7)
				oData<=7'b1110111;
			else if(music>=8&&music<=14)
				oData<=7'b0111111;
			else oData<=7'b1111111;
		
		end
		else begin//音符记号
			oData<=0;
			cnt<=0;
			if(music>0&&music<22)begin
				if(music>=15)begin
					Choose<=8'b11111011;
					iData<=music-5'd14;
				end 
				else if(music<=7)begin
					Choose<=8'b11111110;
					iData<=music;
				end 
				else begin
					Choose=8'b11111101;
					iData<=music-5'd7;
				end
			end 
			else Choose<=8'b11111111;
			casex(iData)
				4'b0000:oData<=7'b1000000;
    			4'b0001:oData<=7'b1111001;
    			4'b0010:oData<=7'b0100100;
    			4'b0011:oData<=7'b0110000;
    			4'b0100:oData<=7'b0011001;
    			4'b0101:oData<=7'b0010010;
    			4'b0110:oData<=7'b0000010;
    			4'b0111:oData<=7'b1111000;
    			4'b1000:oData<=7'b0000000;
    			4'b1001:oData<=7'b0010000;
    			default:oData<=7'b1111111;
    		endcase    	
		end	
	end//end else
	end//end always
       
endmodule