`timescale 1ns / 1ps
module tb_reg_file;

    logic        clk, rst_n;
    logic        we, re;
    logic [7:0]  addr;
    logic [31:0] wdata;
    logic [31:0] rdata;

    reg_file dut (
        .clk, .rst_n,
        .we, .re, .addr, .wdata,
        .rdata
    );

    // clock
    initial clk = 0;
    always #5 clk = ~clk;

    task automatic do_write(input logic [7:0] a, input logic [31:0] d);
        @(posedge clk);
        we   <= 1; re <= 0;
        addr <= a;
        wdata<= d;
        @(posedge clk);
        we   <= 0;
    endtask

    task automatic do_read_check(input logic [7:0] a, input logic [31:0] exp);
        @(posedge clk);
        re   <= 1; we <= 0;
        addr <= a;
        @(posedge clk); // rdata is combinational, but sample on clock edge for TB stability
        assert (rdata === exp)  //rdata와 exp 값이 같지 않다면 에러 발생
        else $fatal("READ MISMATCH addr=%h exp=%h got=%h", a, exp, rdata);
        re <= 0;
    endtask

    initial begin
        // init
        we = 0; re = 0; addr = 0; wdata = 0;
        rst_n = 0;

        // synchronous reset: hold low, then release on a clock edge
        repeat (2) @(posedge clk);
        rst_n <= 1;

        // reset 후 값 확인
        do_read_check(8'h00, 32'h0);    
        do_read_check(8'h04, 32'h0);    
        do_read_check(8'h08, 32'h0);    
        do_read_check(8'h0C, 32'h0);    

        // write → read → assert
        do_write(8'h00, 32'hDEADBEEF);  //addr=8'h00, wdata=32'hDEADBEEF
        do_read_check(8'h00, 32'hDEADBEEF); // rdata==32'hDEADBEEF?

        do_write(8'h0C, 32'h12345678);
        do_read_check(8'h0C, 32'h12345678);

        // 잘못된 주소 접근 테스트 (0x10은 invalid)
        do_write(8'h10, 32'hAAAAAAAA);       // should be ignored
        do_read_check(8'h10, 32'h0);         // policy: invalid -> 0
        do_read_check(8'h00, 32'hDEADBEEF);  // reg0 유지 확인

        $display("ALL TESTS PASSED");
        $finish;
    end

endmodule
