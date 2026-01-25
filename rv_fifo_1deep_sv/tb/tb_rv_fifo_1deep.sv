`timescale 1ns/1ps

module tb_rv_fifo_1deep;

  localparam int DW = 32;

  // DUT I/O
  logic clk, rst_n;

  logic           in_valid;
  logic           in_ready;
  logic [DW-1:0]  in_data;

  logic           out_valid;
  logic           out_ready;
  logic [DW-1:0]  out_data;

  // Instantiate DUT
  rv_fifo_1deep #(.DW(DW)) dut (
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .in_ready(in_ready),
    .in_data(in_data),
    .out_valid(out_valid),
    .out_ready(out_ready),
    .out_data(out_data)
  );

  // clock
  initial clk = 1'b0;
  always #5 clk = ~clk;

  // handshake events
  logic push, pop;
  assign push = in_valid  & in_ready;
  assign pop  = out_valid & out_ready;

  // reference model (1-depth)
  logic           ref_full;
  logic [DW-1:0]  ref_data;

  // stimulus control
  logic run_random;
  int unsigned next_payload;
  int unsigned cycle;

  // -----------------------
  // Reset task
  // -----------------------
  task automatic do_reset();
    begin
      rst_n = 1'b0;

      // TB-driven signals init
      in_valid    = 1'b0;       // one-bit zero
      in_data     = '0;         // all of bits are zero
      out_ready   = 1'b0;

      // REF init
      ref_full    = 1'b0;
      ref_data    = '0;

      // counters
      next_payload = 0;
      run_random   = 1'b0;

      repeat (3) @(posedge clk);
      rst_n = 1'b1;
      @(posedge clk);
    end
  endtask

  // -----------------------
  // Assertions (필수 2개)
  // -----------------------
  // stall 동안 out_data 고정 (다음 사이클 기준으로 체크)
  assert property (@(posedge clk) disable iff (!rst_n)                  //assert 정의와 동시에 실행 , 리셋중이면 수행 x
    (out_valid && !out_ready) |=> (out_data == $past(out_data))     //need to hold data when out_valid= 1 && out_ready = 0 , |=> 다음클럭부터 변화
  ) else $fatal(1, "out_data changed while stalled");


  // out_valid는 accept(pop)될 때까지 유지
  assert property (@(posedge clk) disable iff (!rst_n)
    (out_valid && !out_ready) |=> out_valid                         //out_valid must be 1 at next cycle
  ) else $fatal(1, "out_valid dropped before acceptance");

  // -----------------------
  // 유일한 드라이버: negedge에서만 stimulus 구동
  // (멀티드라이브 방지)
  // -----------------------
  always @(negedge clk) begin
    if (!rst_n) begin
      out_ready <= 1'b0;
      in_valid  <= 1'b0;
      in_data   <= '0;
    end 
    else if (run_random)                    //random value 생성 및 push 발생 시 data update
    begin
      // random backpressure
      out_ready <= $urandom_range(0,1);

      // random valid (70% 확률)
      in_valid  <= ($urandom_range(0,99) < 70);

      // sender rule: push일 때만 data 갱신
    if (in_valid && in_ready) 
      begin       //push!
        in_data <= next_payload[DW-1:0];    //   data update at negedge && push
      end
      // else: in_data 유지 (stall 동안 data stable)
    end 
    
    else // 300 cycle end , run_random = 0 
    begin
      // drain mode
      out_ready <= 1'b1;
      in_valid  <= 1'b0;
      // in_data는 의미 없음(유효 아님) -> 그대로 둬도 됨
    end
  end

  // -----------------------
  // Reference model + checking (posedge에서)
  // -----------------------
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      ref_full <= 1'b0;
      ref_data <= '0;
    end else begin
      // pop 발생 시 데이터 체크 pop = out_valid= 1 , out_ready= 1, full= 1일때 발생
      if (pop) 
      begin
        if (!ref_full) $fatal(1, "REF underflow: pop but ref_full=0");              // pop에서 full=0 은 오류
        if (out_data !== ref_data) $fatal(1, "DATA mismatch: exp=0x%08h got=0x%08h", ref_data, out_data);       
      end

      // ref 상태 업데이트
      unique case ({push, pop})
        2'b10: begin // push only
          if (ref_full) $fatal(1, "REF overflow: push but ref_full=1");
          ref_data <= in_data;
          ref_full <= 1'b1;
          next_payload <= next_payload + 1;
        end
        2'b01: begin // pop only
          ref_full <= 1'b0;
        end
        2'b11: begin // push & pop
          ref_data <= in_data;  // replace with new
          ref_full <= 1'b1;
          next_payload <= next_payload + 1;
        end
        default: ; // no event
      endcase
    end
  end

  // -----------------------
  // Main test sequence
  // -----------------------
  initial begin
    do_reset();

    // 1) random test phase
    run_random = 1'b1;
    for (cycle = 0; cycle < 300; cycle++) begin
      @(posedge clk);
    end

    // 2) drain phase
    run_random = 1'b0;
    repeat (20) @(posedge clk);

    // drain 확인: DUT와 REF 둘 다 비어야 함
    if (out_valid) $fatal(1, "Drain failed: DUT still valid");
    if (ref_full)  $fatal(1, "Drain failed: ref_full still 1");

    $display("PASS ? Project 1 TB complete");
    $finish;
  end

endmodule
