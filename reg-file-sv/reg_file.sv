`timescale 1ns / 1ps

module reg_file (
    input  logic        clk,    // clock 
    input  logic        rst_n,   // synchronous reset (active-low)

    input  logic        we,     // write enable
    input  logic        re,     // read enable
    input  logic [7:0]  addr,   // byte address (0x00,0x04,0x08,0x0C)
    input  logic [31:0] wdata,  // input data

    output logic [31:0] rdata   // output data
);

    logic [31:0] regs [0:3];    //32bit register x 4 
    logic [1:0]  idx;           // register index , 00 01 10 11
    logic        addr_valid;    //valid

    // address decode
    
    assign  idx        = addr[3:2];                 // 0x0/0x4/0x8/0xC address index
    assign  addr_valid = (addr == 8'h00) || (addr == 8'h04) || (addr == 8'h08) || (addr == 8'h0C);  // if 0x0,4,8,C => addr_valid = 1 
    

    // write path (always_ff)
    always_ff @(posedge clk) begin
        if (!rst_n) begin   //(active low) rst= 0 => if  / rst= 1 => else if 
            regs[0] <= '0;
            regs[1] <= '0;
            regs[2] <= '0;
            regs[3] <= '0;
        end else if (we && addr_valid) begin
            regs[idx] <= wdata;
        end
    end

    // read mux (always_comb)
    always_comb begin
        if (re && addr_valid) begin
            rdata = regs[idx];
        end else begin
            rdata = 32'h0;
        end
    end

endmodule

