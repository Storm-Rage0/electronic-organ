`timescale 1ns / 1ps



module Rotation(//旋转编码器
    input clk,			//系统时钟
    input iA,			//旋转编码器A管脚
    input iB,			//旋转编码器B管脚
    input SW,			//旋转编码器D管脚
	input rst,			//编码器复位，高有效
    output reg	[1:0] odata//输出编码
);
 
	integer i=0;
//计数器周期为500us，控制键值采样频率
	wire clk_2kHZ;
	Divider_2kHZ(clk,0,clk_2kHZ);

    reg	 key_a_r,key_a_r1;
    reg key_b_r,key_b_r1;
    reg key_sw_r;
 
//针对A、B、SW管脚分别做简单去抖操作，

//对旋转编码器的输入缓存，消除亚稳态同时延时锁存
	always@(posedge clk_2kHZ) begin
		i=i+1;
		key_a_r		<=	iA;
		key_a_r1	<=	key_a_r;
		key_b_r		<=	iB;
		key_b_r1	<=	key_b_r;
		if(i==40) begin	//对于按键信号采用20ms周期采样的方法，40*500us = 20ms
			i=0;			
			key_sw_r <= SW;
		end 
		else 
			key_sw_r <=	key_sw_r;
	end
 
	reg 	key_sw_r1;
	
	//对按键D信号进行延时锁存
	always@(posedge clk_2kHZ) 	
		key_sw_r1 <= key_sw_r;	
 
	wire	A_state		= key_a_r1 && key_a_r && iA;	//旋转编码器A信号高电平状态检测
	wire	B_state		= key_b_r1 && key_b_r && iB;	//旋转编码器B信号高电平状态检测
 
	reg	 A_state_reg;
	
	//延时锁存
	always@(posedge clk_2kHZ)
		A_state_reg <= A_state;
	
 
	//旋转编码器A信号的上升沿和下降沿检测
	wire	A_pos	= (!A_state_reg) && A_state;
	wire	A_neg	= A_state_reg && (!A_state);
 
	//通过旋转编码器A信号的边沿和B信号的电平状态的组合判断旋转编码器的操作，并输出对应的脉冲信号
	always@(posedge clk_2kHZ or posedge rst)begin
		if(rst==1) odata=2'b00;
		else if(A_pos && B_state) odata=2'b01;	
		else if(A_neg && B_state) odata=2'b10;
		else if(key_sw_r1 && (!key_sw_r)) odata=2'b11;		//旋转编码器D信号下降沿检测odata=2'b00;
		else if (key_sw_r && (!key_sw_r1))odata=2'b00;
	end
    
	endmodule