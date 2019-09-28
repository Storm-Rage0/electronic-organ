`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/04 21:19:51
// Design Name: 
// Module Name: Beeper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Beeper//蜂鸣器输出对应频率
(
input					clk_in,		//系统时钟
input					rst_n_in,	//系统复位，低有效
input					tone_en,	//蜂鸣器使能信号，高有效
input			[4:0]	tone,		//蜂鸣器音调控置
input 			[1:0]	lifting_mark,//音调升降记号
output	reg				piano_out	//蜂鸣器控制输出
);

reg [17:0] time_end;
//根据不同的音节控制，选择对应的计数终值
//低音1的频率为261.6Hz，蜂鸣器控制信号周期100M/261.6/2
always@(tone) begin
	case({lifting_mark[1:0],tone[4:0]})
		//标准音
		7'd1:	time_end =	18'd191109;	//L1,
		7'd2:	time_end =	18'd170265;	//L2,
		7'd3:	time_end =	18'd151685;	//L3,
		7'd4:	time_end =	18'd143172;	//L4,
		7'd5:	time_end =	18'd127551;	//L5,
		7'd6:	time_end =	18'd113636;	//L6,
		7'd7:	time_end =	18'd101239;	//L7,
		7'd8:	time_end =	18'd95557;	//M1,
		7'd9:	time_end =	18'd85131;	//M2,
		7'd10:	time_end =	18'd75843;	//M3,
		7'd11:	time_end =	18'd71586;	//M4,
		7'd12:	time_end =	18'd63776;	//M5,
		7'd13:	time_end =	18'd56818;	//M6,
		7'd14:	time_end =	18'd50619;	//M7,
		7'd15:	time_end =	18'd47778;	//H1,
		7'd16:	time_end =	18'd42566;	//H2,
		7'd17:	time_end =	18'd37921;	//H3,
		7'd18:	time_end =	18'd35793;	//H4,
		7'd19:	time_end =	18'd31888;	//H5,
		7'd20:	time_end =	18'd28409;	//H6,
		7'd21:	time_end =	18'd25307;	//H7,
		//升调		
		7'd65:time_end=18'd180388;
		7'd66:time_end=18'd160705;
		7'd67:time_end=18'd151685;
		7'd68:time_end=18'd135139;
		7'd69:time_end=18'd120395;
		7'd70:time_end=18'd107259;
		7'd71:time_end=18'd101239;
		
		7'd72:time_end=18'd90192;
		7'd73:time_end=18'd80354;
		7'd74:time_end=18'd75843;
		7'd75:time_end=18'd67568;
		7'd76:time_end=18'd60197;
		7'd77:time_end=18'd53629;
		7'd78:time_end=18'd50619;
		
		7'd79:time_end=18'd45097;
		7'd80:time_end=18'd40176;
		7'd81:time_end=18'd37922;
		7'd82:time_end=18'd33784;
		7'd83:time_end=18'd30098;
		7'd84:time_end=18'd26815;
		7'd85:time_end=18'd25307;
		
		//降调
		7'd33:time_end=18'd191109;
		7'd34:time_end=18'd180388;
		7'd35:time_end=18'd160705;
		7'd36:time_end=18'd143172;
		7'd37:time_end=18'd135139;
		7'd38:time_end=18'd120395;
		7'd39:time_end=18'd107259;
		
		7'd40:time_end=18'd95557;		
		7'd41:time_end=18'd90192;
		7'd42:time_end=18'd80354;
		7'd43:time_end=18'd71586;
		7'd44:time_end=18'd67568;
		7'd45:time_end=18'd60197;
		7'd46:time_end=18'd53629;
		
		7'd47:time_end=18'd47778;		
		7'd48:time_end=18'd45097;
		7'd49:time_end=18'd40176;
		7'd50:time_end=18'd35793;
		7'd51:time_end=18'd33784;
		7'd52:time_end=18'd30098;
		7'd53:time_end=18'd26815;
		default:time_end =	18'd1;	
	endcase
end
 
reg [17:0] time_cnt;
//当蜂鸣器使能时，计算分频值
always@(posedge clk_in or negedge rst_n_in) begin
	if(!rst_n_in) begin
		time_cnt <= 1'b0;
	end else if(!tone_en) begin
		time_cnt <= 1'b0;
	end else if(time_cnt>=time_end) begin
		time_cnt <= 1'b0;
	end else begin
		time_cnt <= time_cnt + 1'b1;
	end
end
 
//根据计数器的周期，翻转蜂鸣器控制信号
always@(posedge clk_in or negedge rst_n_in) begin
	if(!rst_n_in) begin
		piano_out <= 1'b0;
	end else if(time_cnt==time_end) begin
		piano_out <= ~piano_out;	//蜂鸣器控制输出翻转，两次翻转为1Hz
	end else begin
		piano_out <= piano_out;
	end
end
 
endmodule


