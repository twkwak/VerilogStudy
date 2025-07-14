`timescale 1ns / 1ps


module my_dff ( input clk, input d, output reg q ); //하위모듈 생성
    always @(posedge clk) //D플립플롭
        q <= d;
endmodule

module module_shift ( input clk, input d, output q ); //상위모듈 생성

    wire q1,q2;   
    my_dff dff0(.clk(clk),.d(d),.q(q1));  //첫번째 플립플롭 인스턴스화
    my_dff dff1(.clk(clk),.d(q1),.q(q2)); //두번째 플립플롭 인스턴스화
    my_dff dff2(.clk(clk),.d(q2),.q(q));  //세번째 플립플롭 인스턴스화
endmodule

