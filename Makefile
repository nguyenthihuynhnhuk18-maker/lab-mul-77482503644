# Makefile cua repo bo nhan - Lab 2: Phan 4 dien TODO 1-8, Phan 5 dien TODO 9.
# Moi lenh chay tu thu muc goc cua repo.

TOP    = mul16
TB_TOP = tb_mul16_smoke
# TODO 1: RTL = moi file .sv trong rtl/, TB = moi file .sv trong tb/  (dung $(wildcard ...))
RTL :=
TB  :=
# Tham so cho lenh trace (mo hinh Python); ghi de duoc: make trace A=200 B=7 W=8
A ?= 13
B ?= 11
W ?= 4

# TODO 2: target help (target dau tien) in danh sach cac lenh ben duoi, dung @echo

# TODO 3: target lint: verilator --lint-only -Wall -Wno-fatal --top-module $(TOP) <cac file RTL>

# TODO 4: target sim: tao thu muc sim, bien dich bang
#   verilator --binary --timing --trace -Wno-fatal -j 0 --top-module $(TB_TOP) -Mdir sim/obj <RTL> <TB>
#   roi chay ./sim/obj/V$(TB_TOP)

# TODO 5: rule tao sim/$(TB_TOP).vvp tu RTL va TB bang iverilog -g2012 -s $(TB_TOP)
#         (dung $@ va $^), va target sim-icarus chay no bang "vvp -n $<"

# TODO 6: target wave: gtkwave sim/dump.vcd &

# TODO 7: target trace: python3 sw/model/mul_model.py $(A) $(B) --w $(W)

# TODO 8: target clean xoa thu muc sim; khai bao .PHONY cho moi target khong phai ten file

# TODO 9 (Lab 2 - Phan 5): target logs chay: tclsh sw/scripts/tong_hop_log.tcl
