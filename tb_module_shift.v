`timescale 1ns / 1ps

module tb_module_shift;

    // 테스트 대상 신호 정의
    reg clk;
    reg d;
    wire q;

    // DUT 인스턴스화
    module_shift dut (.clk(clk),.d(d),.q(q));
    // 클럭 생성: 10ns 주기 (5ns마다 토글)
    always #5 clk = ~clk;
    initial begin
        // 초기값
        clk = 0;
        d = 0;
        // 테스트 시나리오
        #10 d = 1;   // 1을 집어넣기 시작
        #10 d = 0;   // 0으로 바꿈
        #30;         // 잠깐 대기
        #10 d = 1;
        #10 d = 0;
        #50;
        $finish;     // 시뮬레이션 종료
    end
endmodule