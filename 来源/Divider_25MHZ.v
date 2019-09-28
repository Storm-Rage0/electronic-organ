`timescale 1ns / 1ps

//25MHZ分频

module Divider_25MHZ(
    input I_CLK,
    input rst,
    output reg O_CLK
    );
    integer i=0;
    parameter num=2;
    always @ (posedge I_CLK)
    begin
    if(rst==1)
        begin
        O_CLK<=0;
        i<=0;
        end
    else
    begin
        if(i==num-1)
        begin
        O_CLK<=~O_CLK;
        i<=0;
        end//end reset num
        else
        i<=i+1;
    end//end rst==0
    end//end always
endmodule