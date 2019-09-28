`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/24 19:52:41
// Design Name: 
// Module Name: electronic_organ
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


module electronic_organ(clk,reset_keyboard,reset_beeper,key_clk,key_data,ro_ia,ro_ib,ro_sw,vga_r,vga_g,vga_b,vga_hs,vga_vs,music_choose,sound_out,beep_out,seven_choose,seven_data);//顶层模块
	input clk;//系统时钟
	input reset_keyboard;//键盘复位，高有效
	input reset_beeper;//蜂鸣器复位，高有效
	input key_clk;//键盘时钟
	input key_data;//键盘数据输入
	input ro_ia,ro_ib,ro_sw;//旋转编码器输入信号
	input [1:0] music_choose;//音频输出选择.低位控制自带，高位控制外接
	
	output [3:0] vga_r,vga_g,vga_b;//VGA颜色输入
	output vga_hs,vga_vs;//VGA行列同步信号
	
	output sound_out;//外接蜂鸣器输出
	output beep_out;//自带蜂鸣器输出
	output [7:0] seven_choose;//数码管选择
	output [6:0] seven_data;//数码管数字输出
	
	wire keyboard_state;//键盘按下状态
	wire [7:0] keyboard_ascii;//键盘按键的ascii编码值
	wire [4:0] music_note;//蜂鸣器音符位置
	wire [1:0] ro_out;//旋转编码器输出
	wire music_out;//输出频率记录
	
	Keyboard_PS2 keyboard(clk,~reset,key_clk,key_data,keyboard_state,keyboard_ascii);//读取键盘按键，返回其编码
	
	Convert_Ascii_to_Music convert(keyboard_ascii,music_note);//将键盘的键码转化为字符的ascii码
	
	Rotation rotation(clk,ro_ia,ro_ib,ro_sw,~keyboard_state,ro_out);//读取旋转编码器的操作
	
	VGA_port vga_port(clk,0,music_note,vga_r,vga_g,vga_b,vga_hs,vga_vs);//VGA输出
	
	Beeper beeper(clk,~reset_beeper,1,music_note,ro_out,music_out);//蜂鸣器输出
	assign beep_out=music_out&music_choose[0];
	assign sound_out=music_out&music_choose[1];
	
	Seven_Segment segment(music_note,ro_out,0,clk,seven_choose,seven_data);//七段数码管输出
	
	
	
endmodule













