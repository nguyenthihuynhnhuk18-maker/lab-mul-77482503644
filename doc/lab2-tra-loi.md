Q1. Lệnh: tclsh sw/scripts/tong_hop_log.tcl
Kết quả: run_01.log, commit a1f3c09, TREO; run_02 và run_03, commit 5be2d14, FAIL; run_04 và run_05, commit c7e90aa, PASS. Testbench báo có thể req_ready hoặc resp_valid không lên 1.

Q2. Lệnh: tclsh sw/scripts/tong_hop_log.tcl
Kết quả: tổng phép nhân sai là 191. Có 20 dòng LOI vì testbench chỉ in tối đa 10 lỗi mỗi lần chạy; hai log FAIL tạo tối đa 20 dòng chi tiết.
Q3. Lệnh: grep -h LOI logs/*.log | awk '{print $3}' | sort | uniq -c
Kết quả: mọi giá trị b gây lỗi đều có bit 15 bằng 1. FSM có thể đã bỏ qua b[15], chẳng hạn chỉ lặp W−1 lần.

Q4. Lệnh: grep -h 'a=0x0003 b=0x8001' logs/*.log; python3 -c 'print(3 * (0x8001 % 0x8000))'
Kết quả: log p=0x00000003; phép tính khi bỏ bit 15 cũng bằng 3. Tích đúng là 0x00018003.
Q5. Lệnh:
grep -h LOI logs/*.log > doc/loi-mau.txt
wc -l doc/loi-mau.txt
grep -h LOI logs/*.log >> doc/loi-mau.txt
wc -l doc/loi-mau.txt

Kết quả: lần đầu có 20 dòng; dùng >> lần hai thì thành 40 dòng. > ghi đè nội dung file, còn >> nối nội dung mới vào cuối file.
Q6. Trong rtl/mul16.sv đã sửa 6 lỗi:
1. Khai báo kiểu cổng wire/reg → logic (các dòng khai báo cổng, khoảng dòng 13–23).
2. Tên cổng reset → rst (dòng 14).
3. Độ rộng ngõ vào a → [W-1:0] (dòng 18).
4. Thiếu dấu phẩy sau cổng b → thêm dấu phẩy (dòng 19).
5. Tên ngõ ra prod → p (dòng 23).
6. Độ rộng ngõ ra p → [2*W-1:0] (dòng 23).
Q7. Dùng \<prod\> để chỉ khớp nguyên tên cổng prod. Nếu thay prod không có dấu \< \>, Vim có thể thay cả một phần của tên khác, ví dụ product hoặc prod_valid.
Q8. Với W=16, p cần rộng 2W=32 bit. Nếu chỉ để rộng W=16 bit thì kết quả bị cắt còn 16 bit thấp: 0xFFFF × 0xFFFF = 0xFFFE0001, nên p chỉ nhận 0x0001.
Q9. Lệnh: git log --oneline --graph --all

Repo cá nhân:
* 547b64f Hoan thien Makefile va tong hop log
* af1f740 Bo thu muc sim khoi repo
* c6fb2f9 Lo commit sim
* 99bc7fe Them dong ghi chu vao README
*   e53df6e Merge nhanh readme
|\
| * 3ca09f3 Dien ten va MSSV vao README
|/
* 7874a4e Khoi tao repo tu goi phat, sua khai bao cong mul16
* 49e222a Ignore temporary simulation files
* eabf165 Complete Lab 2

Repo binh:
*   a1728af Gop SUB va AND
|\
| * 6dbf640 Binh: them SUB
* | fb597ed An: them AND
|/
* b235963 An: khung ALU
Q10. Push của An bị từ chối vì remote đã có commit mới của Bình mà An chưa có; đây là lỗi non-fast-forward (fetch first). Bình push được vì đã git pull trước, nên commit của Bình dựa trên bản mới nhất từ remote.
Q11. Không commit sim/ vì đây là thư mục chứa file sinh ra khi mô phỏng, có thể tạo lại và làm repo nặng. Nếu lỡ commit, dùng git rm -r --cached sim rồi commit thay đổi; lệnh này gỡ sim/ khỏi Git nhưng giữ file trên đĩa.
Q12. Merge fast-forward chỉ di chuyển con trỏ main tới commit mới, không tạo merge commit riêng. Dùng --no-ff thì Git tạo merge commit để lưu lại rõ ràng việc đã gộp nhánh, kể cả khi fast-forward được.
Q13. Lần chạy make sim-icarus thứ hai không biên dịch lại vì file sim/tb_mul16_smoke.vvp đã mới hơn các file nguồn. Khi dùng touch để cập nhật thời gian sửa của rtl/mul16.sv, file nguồn mới hơn nên Make chạy lại lệnh biên dịch.
Q14. Nếu có file tên clean mà target clean không được khai báo .PHONY, Make có thể xem clean là đã cập nhật và bỏ qua lệnh xóa. Khai báo .PHONY: clean để Make luôn chạy target clean.
Q15. Lệnh make trace A=200 B=7 W=8 truyền giá trị A, B, W vào Makefile. Vì các biến dùng ?=, giá trị mặc định chỉ được gán khi biến chưa có giá trị; giá trị truyền trên dòng lệnh sẽ được dùng.
Q16. Trong Tcl, dấu ngoặc kép cho phép thay biến: puts "W = $w" in ra giá trị của w. Ngoặc nhọn gom nội dung thành một nhóm và không thay biến: puts {W = $w} in nguyên văn W = $w.
Q17. Sửa script tong_hop_log.tcl để tính phần trăm lỗi trên 206 phép nhân: lấy số lỗi chia 206 rồi nhân 100. run_02 có 103 lỗi (50.0%), run_03 có 88 lỗi (42.7%), các log PASS có 0 lỗi (0.0%); log TREO ghi dấu "-".
Q18. Tcl được dùng trong Yosys, OpenSTA và OpenROAD để viết script tự động hóa các bước thiết kế. Biến, vòng lặp và lệnh xử lý file của Tcl giúp chạy cùng quy trình trên nhiều file và thiết lập.
