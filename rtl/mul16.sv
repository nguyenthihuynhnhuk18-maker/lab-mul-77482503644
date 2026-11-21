`timescale 1ns/1ps
// =============================================================
// Bo nhan W x W bit, giao tiep valid/ready. Dac ta: doc/dac-ta.md
//
// Lab 2 - Phan 2: phan khai bao cong duoi day co 6 cho SAI so voi
//                 bang cong trong dac ta. Sua bang vi.
// Lab 5         : khai bao trang thai va thanh ghi (TODO ben duoi),
//                 viet bo dieu khien va datapath, xoa doan TAM THOI.
// =============================================================
module mul16 #(
    parameter int W = 16
) (
    input  logic            clk,
    input  logic            rst,
    // phia yeu cau
    input  logic            req_valid,
    output logic             req_ready,
    input  logic  [W-1:0]     a,
    input  logic  [W-1:0]   b,
    // phia ket qua
    output logic             resp_valid,
    input  logic            resp_ready,
    output logic   [2*W-1:0]   p
);
    // TODO (Lab 5): kieu enum cho 3 trang thai, bien state va state_next

    // TODO (Lab 5): khai bao 4 thanh ghi cua datapath theo bang
    //                        "Thanh ghi" trong dac ta (ten, do rong)

    // ===== TAM THOI: gan hang so de bien dich duoc. Xoa o Lab 5. =====
    assign req_ready  = 1'b0;
    assign resp_valid = 1'b0;
    assign p       = '0;
endmodule
