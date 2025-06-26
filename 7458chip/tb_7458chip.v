`timescale 1ns / 1ps

module tb_chip7458;

    // 입력 신호 reg 선언
    reg p1a, p1b, p1c, p1d, p1e, p1f;
    reg p2a, p2b, p2c, p2d;

    // 출력 신호 wire 선언
    wire p1y, p2y;

    // DUT 인스턴스
    chip7458 uut (
        .p1a(p1a), .p1b(p1b), .p1c(p1c),
        .p1d(p1d), .p1e(p1e), .p1f(p1f),
        .p1y(p1y),
        .p2a(p2a), .p2b(p2b), .p2c(p2c), .p2d(p2d),
        .p2y(p2y)
    );

    initial begin
        // 초기화
        p1a = 0; p1b = 0; p1c = 0;
        p1d = 0; p1e = 0; p1f = 0;
        p2a = 0; p2b = 0; p2c = 0; p2d = 0;

        // case 1: p1a~p1c = 1 → p1y = 1
        #10 p1a=1; p1b=1; p1c=1;   

        // case 2: p1d~p1f = 1 → p1y = 1
        #10 p1a=0; p1b=0; p1c=0;
            p1d=1; p1e=1; p1f=1;

        // case 3: p2a & p2b = 1 → p2y = 1
        #10 p2a=1; p2b=1;

        // case 4: p2c & p2d = 1 → p2y = 1
        #10 p2a=0; p2b=0; p2c=1; p2d=1;

        // case 5: 모두 0 → p1y = 0, p2y = 0
        #10 p1d=0; p1e=0; p1f=0; p2c=0; p2d=0;


        #10 $finish;
    end

endmodule

