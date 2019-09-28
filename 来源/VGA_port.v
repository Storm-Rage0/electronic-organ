`timescale 1ns / 1ps

//VGA显示数字

module VGA_port(clk,rst,music_note,R,G,B,HS,VS);//rst高电平有效
	input clk,rst;
	input [4:0] music_note;
	output reg [3:0]R;
	output reg [3:0]G;
	output reg[3:0] B;
	output HS,VS;
	
	//行参数x
	parameter H_CNT_MAX=10'd800;
	parameter H_HS=10'd96;
	parameter H_BP=10'd48;
	parameter H_DISP=10'd640;
	parameter H_FP=10'd16;
	parameter H_Left=H_HS+H_BP;
	parameter H_Right=H_HS+H_BP+H_DISP;
	
	parameter Left_11=10'd250;
	parameter Right_11=10'd258;
	parameter Left_21=10'd294;
	parameter Right_21=10'd302;
	parameter Left_22=10'd326;	
	parameter Right_22=10'd334;
	parameter Left_31=10'd370;	
	parameter Right_31=10'd378;
	parameter Left_32=10'd402;	
	parameter Right_32=10'd410;
	parameter Left_41=10'd446;	
	parameter Right_41=10'd452;
	parameter Left_42=10'd478;	
	parameter Right_42=10'd486;
	parameter Left_51=10'd522;	
	parameter Right_51=10'd530;
	parameter Left_52=10'd554;	
	parameter Right_52=10'd562;
	parameter Left_61=10'd598;	
	parameter Right_61=10'd606;
	parameter Left_62=10'd630;	
	parameter Right_62=10'd638;
	parameter Left_71=10'd674;	
	parameter Right_71=10'd682;
	parameter Left_72=10'd706;	
	parameter Right_72=10'd714;
	
	
	//列参数y
	parameter V_CNT_MAX=10'd600;
	parameter V_HS=10'd2;
	parameter V_BP=10'd29;
	parameter V_DISP=10'd480;
	parameter V_FP=10'd10;
	parameter V_Left=V_HS+V_BP;
	parameter V_Right=V_HS+V_BP+V_DISP;
	
	parameter High_11=10'd71;
	parameter Low_11=10'd147;
	parameter Mid_11=10'd107;
	
	parameter width=10'd130;
	
	reg [9:0 ] h_cnt,v_cnt;
	reg diaplay_reg_note;
	wire disp_valid;
	wire disp_11,disp_22,disp_33,display_note;
	wire clk_25MHz,clk_2kHZ;	
	
	//分频得到25MHz时钟	
	Divider_25MHZ CLK_25MHZ(clk,0,clk_25MHz);		
	
	
	//行列扫描
	always @ (posedge clk_25MHz or posedge rst)begin
		if(rst)begin
			h_cnt<=0;
			v_cnt<=0;
		end
		else begin
			if(h_cnt==(H_CNT_MAX-1))begin
				h_cnt<=0;
				if(v_cnt==(V_CNT_MAX-1))
					v_cnt<=0;
				else
					v_cnt<=v_cnt+1;
				end
			else
				h_cnt<=h_cnt+1;
			end
		end
		
		//HS
		assign HS=(h_cnt<H_HS)?1'b0:1'b1;
		
		//VS
		assign VS=(v_cnt<V_HS)?1'b0:1'b1;
		
		//valid region for diaplay
		assign disp_valid=((h_cnt>=H_Left)&&(h_cnt<H_Right)&&(v_cnt>=V_Left)&&(v_cnt<V_Right))?1'b1:1'b0;
		
		always @ (*)begin//diaplay_reg_note将music_reg_note转化为对应的位置
			case(music_note)
				0:diaplay_reg_note=0;
				
				1:diaplay_reg_note=((h_cnt>=Left_11)&&(h_cnt<=Right_11)&&(v_cnt>=High_11)&&(v_cnt<=(Low_11+8)));
				2:diaplay_reg_note=((h_cnt>=Left_21)&&(h_cnt<=Right_22)&&(v_cnt>=High_11)&&(v_cnt<=(High_11+8)))||
										((h_cnt>=Left_21)&&(h_cnt<=Right_22)&&(v_cnt>=Mid_11)&&(v_cnt<=(Mid_11+8)))||
										((h_cnt>=Left_21)&&(h_cnt<=Right_22)&&(v_cnt>=Low_11)&&(v_cnt<=(Low_11+8)))||
										((h_cnt>=Left_22)&&(h_cnt<=Right_22)&&(v_cnt>=High_11)&&(v_cnt<=Mid_11))||
										((h_cnt>=Left_21)&&(h_cnt<=Right_21)&&(v_cnt>=Mid_11)&&(v_cnt<=Low_11));
				3:diaplay_reg_note=((h_cnt>=Left_32)&&(h_cnt<=Right_32)&&(v_cnt>=High_11)&&(v_cnt<=(Low_11+8)))||
										((h_cnt>=Left_31)&&(h_cnt<=Right_32)&&(v_cnt>=High_11)&&(v_cnt<=(High_11+8)))||
										((h_cnt>=Left_31)&&(h_cnt<=Right_32)&&(v_cnt>=Mid_11)&&(v_cnt<=(Mid_11+8)))||
										((h_cnt>=Left_31)&&(h_cnt<=Right_32)&&(v_cnt>=Low_11)&&(v_cnt<=(Low_11+8)));
				4:diaplay_reg_note=((h_cnt>=Left_42)&&(h_cnt<=Right_42)&&(v_cnt>=High_11)&&(v_cnt<=(Low_11+8)))||
										((h_cnt>=Left_41)&&(h_cnt<=Right_41)&&(v_cnt>=High_11)&&(v_cnt<=Mid_11))||
										((h_cnt>=Left_41)&&(h_cnt<=Right_42)&&(v_cnt>=Mid_11)&&(v_cnt<=(Mid_11+8)));
				5:diaplay_reg_note=((h_cnt>=Left_51)&&(h_cnt<=Right_52)&&(v_cnt>=High_11)&&(v_cnt<=(High_11+8)))||
										((h_cnt>=Left_51)&&(h_cnt<=Right_52)&&(v_cnt>=Mid_11)&&(v_cnt<=(Mid_11+8)))||
										((h_cnt>=Left_51)&&(h_cnt<=Right_52)&&(v_cnt>=Low_11)&&(v_cnt<=(Low_11+8)))||
										((h_cnt>=Left_51)&&(h_cnt<=Right_51)&&(v_cnt>=High_11)&&(v_cnt<=Mid_11))||
										((h_cnt>=Left_52)&&(h_cnt<=Right_52)&&(v_cnt>=Mid_11)&&(v_cnt<=Low_11));
				6:diaplay_reg_note=((h_cnt>=Left_61)&&(h_cnt<=Right_62)&&(v_cnt>=High_11)&&(v_cnt<=(High_11+8)))||
										((h_cnt>=Left_61)&&(h_cnt<=Right_62)&&(v_cnt>=Mid_11)&&(v_cnt<=(Mid_11+8)))||
										((h_cnt>=Left_61)&&(h_cnt<=Right_62)&&(v_cnt>=Low_11)&&(v_cnt<=(Low_11+8)))||
										((h_cnt>=Left_61)&&(h_cnt<=Right_61)&&(v_cnt>=High_11)&&(v_cnt<=(Low_11+8)))||
										((h_cnt>=Left_62)&&(h_cnt<=Right_62)&&(v_cnt>=Mid_11)&&(v_cnt<=Low_11));			
				7:diaplay_reg_note=((h_cnt>=Left_72)&&(h_cnt<=Right_72)&&(v_cnt>=High_11)&&(v_cnt<=(Low_11+8)))||
										((h_cnt>=Left_71)&&(h_cnt<=Right_72)&&(v_cnt>=High_11)&&(v_cnt<=(High_11+8)));
				
				8:diaplay_reg_note=((h_cnt>=Left_11)&&(h_cnt<=Right_11)&&(v_cnt>=High_11+width)&&(v_cnt<=(Low_11+8+width)));
				9:diaplay_reg_note=((h_cnt>=Left_21)&&(h_cnt<=Right_22)&&(v_cnt>=High_11+width)&&(v_cnt<=(High_11+8+width)))||
										((h_cnt>=Left_21)&&(h_cnt<=Right_22)&&(v_cnt>=Mid_11+width)&&(v_cnt<=(Mid_11+8+width)))||
										((h_cnt>=Left_21)&&(h_cnt<=Right_22)&&(v_cnt>=Low_11+width)&&(v_cnt<=(Low_11+8+width)))||
										((h_cnt>=Left_22)&&(h_cnt<=Right_22)&&(v_cnt>=High_11+width)&&(v_cnt<=Mid_11+width))||
										((h_cnt>=Left_21)&&(h_cnt<=Right_21)&&(v_cnt>=Mid_11+width)&&(v_cnt<=Low_11+width));
				10:diaplay_reg_note=((h_cnt>=Left_32)&&(h_cnt<=Right_32)&&(v_cnt>=High_11+width)&&(v_cnt<=(Low_11+8+width)))||
										((h_cnt>=Left_31)&&(h_cnt<=Right_32)&&(v_cnt>=High_11+width)&&(v_cnt<=(High_11+8+width)))||
										((h_cnt>=Left_31)&&(h_cnt<=Right_32)&&(v_cnt>=Mid_11+width)&&(v_cnt<=(Mid_11+8+width)))||
										((h_cnt>=Left_31)&&(h_cnt<=Right_32)&&(v_cnt>=Low_11+width)&&(v_cnt<=(Low_11+8+width)));
				11:diaplay_reg_note=((h_cnt>=Left_42)&&(h_cnt<=Right_42)&&(v_cnt>=High_11+width)&&(v_cnt<=(Low_11+8+width)))||
										((h_cnt>=Left_41)&&(h_cnt<=Right_41)&&(v_cnt>=High_11+width)&&(v_cnt<=Mid_11+width))||
										((h_cnt>=Left_41)&&(h_cnt<=Right_42)&&(v_cnt>=Mid_11+width)&&(v_cnt<=(Mid_11+8+width)));
				12:diaplay_reg_note=((h_cnt>=Left_51)&&(h_cnt<=Right_52)&&(v_cnt>=High_11+width)&&(v_cnt<=(High_11+8+width)))||
										((h_cnt>=Left_51)&&(h_cnt<=Right_52)&&(v_cnt>=Mid_11+width)&&(v_cnt<=(Mid_11+8+width)))||
										((h_cnt>=Left_51)&&(h_cnt<=Right_52)&&(v_cnt>=Low_11+width)&&(v_cnt<=(Low_11+8+width)))||
										((h_cnt>=Left_51)&&(h_cnt<=Right_51)&&(v_cnt>=High_11+width)&&(v_cnt<=Mid_11+width))||
										((h_cnt>=Left_52)&&(h_cnt<=Right_52)&&(v_cnt>=Mid_11+width)&&(v_cnt<=Low_11+width));
				13:diaplay_reg_note=((h_cnt>=Left_61)&&(h_cnt<=Right_62)&&(v_cnt>=High_11+width)&&(v_cnt<=(High_11+8+width)))||
										((h_cnt>=Left_61)&&(h_cnt<=Right_62)&&(v_cnt>=Mid_11+width)&&(v_cnt<=(Mid_11+8+width)))||
										((h_cnt>=Left_61)&&(h_cnt<=Right_62)&&(v_cnt>=Low_11+width)&&(v_cnt<=(Low_11+8+width)))||
										((h_cnt>=Left_61)&&(h_cnt<=Right_61)&&(v_cnt>=High_11+width)&&(v_cnt<=(Low_11+8+width)))||
										((h_cnt>=Left_62)&&(h_cnt<=Right_62)&&(v_cnt>=Mid_11+width)&&(v_cnt<=Low_11+width));
				14:diaplay_reg_note=((h_cnt>=Left_72)&&(h_cnt<=Right_72)&&(v_cnt>=High_11+width)&&(v_cnt<=(Low_11+8+width)))||
										((h_cnt>=Left_71)&&(h_cnt<=Right_72)&&(v_cnt>=High_11+width)&&(v_cnt<=(High_11+8+width)));
				
				15:diaplay_reg_note=((h_cnt>=Left_11)&&(h_cnt<=Right_11)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(Low_11+8+width*2)));
				16:diaplay_reg_note=((h_cnt>=Left_21)&&(h_cnt<=Right_22)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(High_11+8+width*2)))||
										((h_cnt>=Left_21)&&(h_cnt<=Right_22)&&(v_cnt>=Mid_11+width*2)&&(v_cnt<=(Mid_11+8+width*2)))||
										((h_cnt>=Left_21)&&(h_cnt<=Right_22)&&(v_cnt>=Low_11+width*2)&&(v_cnt<=(Low_11+8+width*2)))||
										((h_cnt>=Left_22)&&(h_cnt<=Right_22)&&(v_cnt>=High_11+width*2)&&(v_cnt<=Mid_11+width*2))||
										((h_cnt>=Left_21)&&(h_cnt<=Right_21)&&(v_cnt>=Mid_11+width*2)&&(v_cnt<=Low_11+width*2));
				17:diaplay_reg_note=((h_cnt>=Left_32)&&(h_cnt<=Right_32)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(Low_11+8+width*2)))||
										((h_cnt>=Left_31)&&(h_cnt<=Right_32)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(High_11+8+width*2)))||
										((h_cnt>=Left_31)&&(h_cnt<=Right_32)&&(v_cnt>=Mid_11+width*2)&&(v_cnt<=(Mid_11+8+width*2)))||
										((h_cnt>=Left_31)&&(h_cnt<=Right_32)&&(v_cnt>=Low_11+width*2)&&(v_cnt<=(Low_11+8+width*2)));
				18:diaplay_reg_note=((h_cnt>=Left_42)&&(h_cnt<=Right_42)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(Low_11+8+width*2)))||
										((h_cnt>=Left_41)&&(h_cnt<=Right_41)&&(v_cnt>=High_11+width*2)&&(v_cnt<=Mid_11+width*2))||
										((h_cnt>=Left_41)&&(h_cnt<=Right_42)&&(v_cnt>=Mid_11+width*2)&&(v_cnt<=(Mid_11+8+width*2)));
				19:diaplay_reg_note=((h_cnt>=Left_51)&&(h_cnt<=Right_52)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(High_11+8+width*2)))||
										((h_cnt>=Left_51)&&(h_cnt<=Right_52)&&(v_cnt>=Mid_11+width*2)&&(v_cnt<=(Mid_11+8+width*2)))||
										((h_cnt>=Left_51)&&(h_cnt<=Right_52)&&(v_cnt>=Low_11+width*2)&&(v_cnt<=(Low_11+8+width*2)))||
										((h_cnt>=Left_51)&&(h_cnt<=Right_51)&&(v_cnt>=High_11+width*2)&&(v_cnt<=Mid_11+width*2))||
										((h_cnt>=Left_52)&&(h_cnt<=Right_52)&&(v_cnt>=Mid_11+width*2)&&(v_cnt<=Low_11+width*2));
				20:diaplay_reg_note=((h_cnt>=Left_61)&&(h_cnt<=Right_62)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(High_11+8+width*2)))||
										((h_cnt>=Left_61)&&(h_cnt<=Right_62)&&(v_cnt>=Mid_11+width*2)&&(v_cnt<=(Mid_11+8+width*2)))||
										((h_cnt>=Left_61)&&(h_cnt<=Right_62)&&(v_cnt>=Low_11+width*2)&&(v_cnt<=(Low_11+8+width*2)))||
										((h_cnt>=Left_61)&&(h_cnt<=Right_61)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(Low_11+8+width*2)))||
										((h_cnt>=Left_62)&&(h_cnt<=Right_62)&&(v_cnt>=Mid_11+width*2)&&(v_cnt<=Low_11+width*2));
				21:diaplay_reg_note=((h_cnt>=Left_72)&&(h_cnt<=Right_72)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(Low_11+8+width*2)))||
										((h_cnt>=Left_71)&&(h_cnt<=Right_72)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(High_11+8+width*2)));
				
				default:diaplay_reg_note=0;			
		
			endcase
		end
		
		assign display_note=diaplay_reg_note;
		
		assign disp_11=(((h_cnt>=Left_11)&&(h_cnt<=Right_11)&&(v_cnt>=High_11)&&(v_cnt<=(Low_11+8)))||
		
		((h_cnt>=Left_21)&&(h_cnt<=Right_22)&&(v_cnt>=High_11)&&(v_cnt<=(High_11+8)))||
		((h_cnt>=Left_21)&&(h_cnt<=Right_22)&&(v_cnt>=Mid_11)&&(v_cnt<=(Mid_11+8)))||
		((h_cnt>=Left_21)&&(h_cnt<=Right_22)&&(v_cnt>=Low_11)&&(v_cnt<=(Low_11+8)))||
		((h_cnt>=Left_22)&&(h_cnt<=Right_22)&&(v_cnt>=High_11)&&(v_cnt<=Mid_11))||
		((h_cnt>=Left_21)&&(h_cnt<=Right_21)&&(v_cnt>=Mid_11)&&(v_cnt<=Low_11))||
		
		((h_cnt>=Left_32)&&(h_cnt<=Right_32)&&(v_cnt>=High_11)&&(v_cnt<=(Low_11+8)))||
		((h_cnt>=Left_31)&&(h_cnt<=Right_32)&&(v_cnt>=High_11)&&(v_cnt<=(High_11+8)))||
		((h_cnt>=Left_31)&&(h_cnt<=Right_32)&&(v_cnt>=Mid_11)&&(v_cnt<=(Mid_11+8)))||
		((h_cnt>=Left_31)&&(h_cnt<=Right_32)&&(v_cnt>=Low_11)&&(v_cnt<=(Low_11+8)))||
		
		((h_cnt>=Left_42)&&(h_cnt<=Right_42)&&(v_cnt>=High_11)&&(v_cnt<=(Low_11+8)))||
		((h_cnt>=Left_41)&&(h_cnt<=Right_41)&&(v_cnt>=High_11)&&(v_cnt<=Mid_11))||
		((h_cnt>=Left_41)&&(h_cnt<=Right_42)&&(v_cnt>=Mid_11)&&(v_cnt<=(Mid_11+8)))||
		
		((h_cnt>=Left_51)&&(h_cnt<=Right_52)&&(v_cnt>=High_11)&&(v_cnt<=(High_11+8)))||
		((h_cnt>=Left_51)&&(h_cnt<=Right_52)&&(v_cnt>=Mid_11)&&(v_cnt<=(Mid_11+8)))||
		((h_cnt>=Left_51)&&(h_cnt<=Right_52)&&(v_cnt>=Low_11)&&(v_cnt<=(Low_11+8)))||
		((h_cnt>=Left_51)&&(h_cnt<=Right_51)&&(v_cnt>=High_11)&&(v_cnt<=Mid_11))||
		((h_cnt>=Left_52)&&(h_cnt<=Right_52)&&(v_cnt>=Mid_11)&&(v_cnt<=Low_11))||
		
		((h_cnt>=Left_61)&&(h_cnt<=Right_62)&&(v_cnt>=High_11)&&(v_cnt<=(High_11+8)))||
		((h_cnt>=Left_61)&&(h_cnt<=Right_62)&&(v_cnt>=Mid_11)&&(v_cnt<=(Mid_11+8)))||
		((h_cnt>=Left_61)&&(h_cnt<=Right_62)&&(v_cnt>=Low_11)&&(v_cnt<=(Low_11+8)))||
		((h_cnt>=Left_61)&&(h_cnt<=Right_61)&&(v_cnt>=High_11)&&(v_cnt<=(Low_11+8)))||
		((h_cnt>=Left_62)&&(h_cnt<=Right_62)&&(v_cnt>=Mid_11)&&(v_cnt<=Low_11))||
		
		((h_cnt>=Left_72)&&(h_cnt<=Right_72)&&(v_cnt>=High_11)&&(v_cnt<=(Low_11+8)))||
		((h_cnt>=Left_71)&&(h_cnt<=Right_72)&&(v_cnt>=High_11)&&(v_cnt<=(High_11+8))))
		?1'b1:1'b0;
		
		assign disp_22=(((h_cnt>=Left_11)&&(h_cnt<=Right_11)&&(v_cnt>=High_11+width)&&(v_cnt<=(Low_11+8+width)))||
		
		((h_cnt>=Left_21)&&(h_cnt<=Right_22)&&(v_cnt>=High_11+width)&&(v_cnt<=(High_11+8+width)))||
		((h_cnt>=Left_21)&&(h_cnt<=Right_22)&&(v_cnt>=Mid_11+width)&&(v_cnt<=(Mid_11+8+width)))||
		((h_cnt>=Left_21)&&(h_cnt<=Right_22)&&(v_cnt>=Low_11+width)&&(v_cnt<=(Low_11+8+width)))||
		((h_cnt>=Left_22)&&(h_cnt<=Right_22)&&(v_cnt>=High_11+width)&&(v_cnt<=Mid_11+width))||
		((h_cnt>=Left_21)&&(h_cnt<=Right_21)&&(v_cnt>=Mid_11+width)&&(v_cnt<=Low_11+width))||
		
		((h_cnt>=Left_32)&&(h_cnt<=Right_32)&&(v_cnt>=High_11+width)&&(v_cnt<=(Low_11+8+width)))||
		((h_cnt>=Left_31)&&(h_cnt<=Right_32)&&(v_cnt>=High_11+width)&&(v_cnt<=(High_11+8+width)))||
		((h_cnt>=Left_31)&&(h_cnt<=Right_32)&&(v_cnt>=Mid_11+width)&&(v_cnt<=(Mid_11+8+width)))||
		((h_cnt>=Left_31)&&(h_cnt<=Right_32)&&(v_cnt>=Low_11+width)&&(v_cnt<=(Low_11+8+width)))||
		
		((h_cnt>=Left_42)&&(h_cnt<=Right_42)&&(v_cnt>=High_11+width)&&(v_cnt<=(Low_11+8+width)))||
		((h_cnt>=Left_41)&&(h_cnt<=Right_41)&&(v_cnt>=High_11+width)&&(v_cnt<=Mid_11+width))||
		((h_cnt>=Left_41)&&(h_cnt<=Right_42)&&(v_cnt>=Mid_11+width)&&(v_cnt<=(Mid_11+8+width)))||
		
		((h_cnt>=Left_51)&&(h_cnt<=Right_52)&&(v_cnt>=High_11+width)&&(v_cnt<=(High_11+8+width)))||
		((h_cnt>=Left_51)&&(h_cnt<=Right_52)&&(v_cnt>=Mid_11+width)&&(v_cnt<=(Mid_11+8+width)))||
		((h_cnt>=Left_51)&&(h_cnt<=Right_52)&&(v_cnt>=Low_11+width)&&(v_cnt<=(Low_11+8+width)))||
		((h_cnt>=Left_51)&&(h_cnt<=Right_51)&&(v_cnt>=High_11+width)&&(v_cnt<=Mid_11+width))||
		((h_cnt>=Left_52)&&(h_cnt<=Right_52)&&(v_cnt>=Mid_11+width)&&(v_cnt<=Low_11+width))||
		
		((h_cnt>=Left_61)&&(h_cnt<=Right_62)&&(v_cnt>=High_11+width)&&(v_cnt<=(High_11+8+width)))||
		((h_cnt>=Left_61)&&(h_cnt<=Right_62)&&(v_cnt>=Mid_11+width)&&(v_cnt<=(Mid_11+8+width)))||
		((h_cnt>=Left_61)&&(h_cnt<=Right_62)&&(v_cnt>=Low_11+width)&&(v_cnt<=(Low_11+8+width)))||
		((h_cnt>=Left_61)&&(h_cnt<=Right_61)&&(v_cnt>=High_11+width)&&(v_cnt<=(Low_11+8+width)))||
		((h_cnt>=Left_62)&&(h_cnt<=Right_62)&&(v_cnt>=Mid_11+width)&&(v_cnt<=Low_11+width))||
		
		((h_cnt>=Left_72)&&(h_cnt<=Right_72)&&(v_cnt>=High_11+width)&&(v_cnt<=(Low_11+8+width)))||
		((h_cnt>=Left_71)&&(h_cnt<=Right_72)&&(v_cnt>=High_11+width)&&(v_cnt<=(High_11+8+width))))
		?1'b1:1'b0;
		
		assign disp_33=(((h_cnt>=Left_11)&&(h_cnt<=Right_11)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(Low_11+8+width*2)))||
		
		((h_cnt>=Left_21)&&(h_cnt<=Right_22)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(High_11+8+width*2)))||
		((h_cnt>=Left_21)&&(h_cnt<=Right_22)&&(v_cnt>=Mid_11+width*2)&&(v_cnt<=(Mid_11+8+width*2)))||
		((h_cnt>=Left_21)&&(h_cnt<=Right_22)&&(v_cnt>=Low_11+width*2)&&(v_cnt<=(Low_11+8+width*2)))||
		((h_cnt>=Left_22)&&(h_cnt<=Right_22)&&(v_cnt>=High_11+width*2)&&(v_cnt<=Mid_11+width*2))||
		((h_cnt>=Left_21)&&(h_cnt<=Right_21)&&(v_cnt>=Mid_11+width*2)&&(v_cnt<=Low_11+width*2))||
		
		((h_cnt>=Left_32)&&(h_cnt<=Right_32)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(Low_11+8+width*2)))||
		((h_cnt>=Left_31)&&(h_cnt<=Right_32)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(High_11+8+width*2)))||
		((h_cnt>=Left_31)&&(h_cnt<=Right_32)&&(v_cnt>=Mid_11+width*2)&&(v_cnt<=(Mid_11+8+width*2)))||
		((h_cnt>=Left_31)&&(h_cnt<=Right_32)&&(v_cnt>=Low_11+width*2)&&(v_cnt<=(Low_11+8+width*2)))||
		
		((h_cnt>=Left_42)&&(h_cnt<=Right_42)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(Low_11+8+width*2)))||
		((h_cnt>=Left_41)&&(h_cnt<=Right_41)&&(v_cnt>=High_11+width*2)&&(v_cnt<=Mid_11+width*2))||
		((h_cnt>=Left_41)&&(h_cnt<=Right_42)&&(v_cnt>=Mid_11+width*2)&&(v_cnt<=(Mid_11+8+width*2)))||
		
		((h_cnt>=Left_51)&&(h_cnt<=Right_52)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(High_11+8+width*2)))||
		((h_cnt>=Left_51)&&(h_cnt<=Right_52)&&(v_cnt>=Mid_11+width*2)&&(v_cnt<=(Mid_11+8+width*2)))||
		((h_cnt>=Left_51)&&(h_cnt<=Right_52)&&(v_cnt>=Low_11+width*2)&&(v_cnt<=(Low_11+8+width*2)))||
		((h_cnt>=Left_51)&&(h_cnt<=Right_51)&&(v_cnt>=High_11+width*2)&&(v_cnt<=Mid_11+width*2))||
		((h_cnt>=Left_52)&&(h_cnt<=Right_52)&&(v_cnt>=Mid_11+width*2)&&(v_cnt<=Low_11+width*2))||
		
		((h_cnt>=Left_61)&&(h_cnt<=Right_62)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(High_11+8+width*2)))||
		((h_cnt>=Left_61)&&(h_cnt<=Right_62)&&(v_cnt>=Mid_11+width*2)&&(v_cnt<=(Mid_11+8+width*2)))||
		((h_cnt>=Left_61)&&(h_cnt<=Right_62)&&(v_cnt>=Low_11+width*2)&&(v_cnt<=(Low_11+8+width*2)))||
		((h_cnt>=Left_61)&&(h_cnt<=Right_61)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(Low_11+8+width*2)))||
		((h_cnt>=Left_62)&&(h_cnt<=Right_62)&&(v_cnt>=Mid_11+width*2)&&(v_cnt<=Low_11+width*2))||
		
		((h_cnt>=Left_72)&&(h_cnt<=Right_72)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(Low_11+8+width*2)))||
		((h_cnt>=Left_71)&&(h_cnt<=Right_72)&&(v_cnt>=High_11+width*2)&&(v_cnt<=(High_11+8+width*2))))
		?1'b1:1'b0;
		
	
		
		
		//diaplay strips,one color per 32 lines,begin from v_cnt=31
		always @ (*) begin
			//black
			R=4'b0000;
			G=4'b0000;
			B=4'b0000;
			
			if(disp_valid)begin
				if(display_note)begin
					R=4'b1111;
					G=4'b0000;
					B=4'b0000;						
				end
				else begin
				if(disp_11)begin
					R=4'b0000;
					G=4'b0000;
					B=4'b1111;
				end
				else if(disp_22)begin
					R=4'b1111;
					G=4'b1111;
					B=4'b0000;			
				end
				else if(disp_33)begin
					R=4'b0000;
					G=4'b1111;
					B=4'b1111;			
				end
				else begin
					R=4'b1111;
					G=4'b1111-v_cnt/32+32;
					B=4'b1111;	
				end
				end//end not display_note
			end
		end
		
	endmodule