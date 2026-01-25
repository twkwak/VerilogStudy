
`timescale 1ns / 1ps

module rv_fifo_1deep 
#(
 parameter int DW = 32
)
(
  input  logic           clk,
  input  logic           rst_n,
//data sender => valid , data receiver => ready 
  // input side
  input  logic           in_valid,  //데이터 주는 valid
  output logic           in_ready,  //데이터 받는 ready, ready=1 => fifo가 받을 준비 완료.
  input  logic [DW-1:0]  in_data,

  // output side
  output logic           out_valid, //valid=1 => fifo가 데이터 전송 가능
  input  logic           out_ready, //ready=1 =>consumer이 받을 준비 완료
  output logic [DW-1:0]  out_data
);

  logic        full;
  logic [DW-1:0] storage;

  // combinational contracts
  assign in_ready  = ~full; //in_ready=1 => full=0 비어있으니 받을 수 있음 
  assign out_valid =  full; //out_valid=1 => full=1 채워져있으니 valid 1 , full=0이면 out_valid 0, pop x
  assign out_data  =  storage;

  // handshake events
  logic push, pop;
  assign push = in_valid  & in_ready;   //full= 0 
  assign pop  = out_valid & out_ready;  //full= 1

  // state update
  always_ff @(posedge clk or negedge rst_n) begin   //register block
    if (!rst_n) begin   // rst_n= 0 => full, storage reset
      full    <= 1'b0;  //in_ready= 1, out_valid= 0 
      storage <= '0;
    end 
    else begin      // rst_n= 1 => empty, 
      unique case ({push, pop})     //non-duplication case
        2'b10: begin    // push only
          storage <= in_data;
          full    <= 1'b1;
        end
        2'b01: begin // pop only
          full    <= 1'b0;          //full=0이면 out_data는 의미 없음
        end                         //storage 값은 남음,  out_valid=0이므로 출력 데이터는 무효
        2'b11: begin // push & pop simultaneously
          storage <= in_data; // replace with new data
          full    <= 1'b1;
        end
        default: ; // no-op
      endcase
    end
  end

endmodule
