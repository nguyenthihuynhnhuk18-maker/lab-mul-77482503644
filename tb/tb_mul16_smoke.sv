`timescale 1ns/1ps
// =============================================================
// Testbench khoi (smoke test) cho mul16 - giang vien phat san.
// 6 truong hop co chu dich + 200 truong hop ngau nhien, so voi a*b.
// Lab 6 se viet testbench day du hon.
// =============================================================
module tb_mul16_smoke;
    localparam int W = 16;

    logic           clk = 0;
    logic           rst;
    logic           req_valid, req_ready;
    logic [W-1:0]   a, b;
    logic           resp_valid, resp_ready;
    logic [2*W-1:0] p, expected;
    int             errors = 0;
    int             n = 0;
    int unsigned    r1, r2;

    mul16 #(.W(W)) dut (
        .clk(clk), .rst(rst),
        .req_valid(req_valid), .req_ready(req_ready), .a(a), .b(b),
        .resp_valid(resp_valid), .resp_ready(resp_ready), .p(p)
    );

    always #5 clk = ~clk;   // chu ky 10 ns

    // Gui mot phep nhan, cho ket qua, so sanh
    task automatic nhan(input logic [W-1:0] x, input logic [W-1:0] y);
        @(negedge clk);
        a = x; b = y; req_valid = 1;
        while (!req_ready) @(negedge clk);
        @(negedge clk);              // canh len vua roi da nhan yeu cau
        req_valid = 0;
        while (!resp_valid) @(negedge clk);
        expected = {{W{1'b0}}, x} * {{W{1'b0}}, y};
        n = n + 1;
        if (p !== expected) begin
            errors = errors + 1;
            if (errors <= 10)
                $display("LOI: a=0x%h b=0x%h p=0x%h mong doi 0x%h", x, y, p, expected);
        end
    endtask

    initial begin
        $dumpfile("sim/dump.vcd");
        $dumpvars(0, tb_mul16_smoke);
        rst = 1; req_valid = 0; resp_ready = 1; a = '0; b = '0;
        repeat (2) @(posedge clk);
        rst = 0;

        nhan(16'd0,     16'd0);
        nhan(16'd1,     16'd1);
        nhan(16'hFFFF,  16'hFFFF);
        nhan(16'h8000,  16'd2);
        nhan(16'd12345, 16'd0);
        nhan(16'd3,     16'h8001);
        repeat (200) begin
            r1 = $urandom;
            r2 = $urandom;
            nhan(r1[W-1:0], r2[W-1:0]);
        end

        if (errors == 0) $display("PASS: %0d/%0d phep nhan dung", n, n);
        else             $display("FAIL: %0d/%0d phep nhan sai", errors, n);
        $finish;
    end

    // Chong treo: neu thiet ke khong bao gio tra loi
    initial begin
        #2000000;
        $display("FAIL: het thoi gian sau %0d phep nhan (req_ready hoac resp_valid khong len 1?)", n);
        $finish;
    end
endmodule
