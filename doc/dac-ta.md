# Đặc tả bộ nhân mul16

Phiên bản 1.0 · dùng chung cho Lab 2 đến Lab 8

## 1. Chức năng

`mul16` nhân hai số không dấu W bit, cho tích 2W bit: `p = a × b`. Mặc định W = 16, tích 32 bit.
Thuật toán dịch-và-cộng, giống nhân tay theo cột nhưng trong hệ nhị phân. Bit thứ i của `b` (bᵢ, i = 0 là bit thấp nhất) có trọng số 2ⁱ, nên

    p = a × b = Σ (i = 0 .. W−1) bᵢ · (a · 2ⁱ)

Nhân `a` với 2ⁱ chính là dịch `a` sang trái i bit (thêm i số 0 bên phải). Vì bᵢ chỉ là 0 hoặc 1, mỗi tích riêng hoặc bằng 0, hoặc bằng `a` đã dịch: chỉ cần bộ dịch và bộ cộng.

Ví dụ W = 4, a = 13 = 1101₂, b = 11 = 1011₂:

| i | bᵢ | a dịch trái i bit | Được cộng vào tổng | Tổng sau bước này |
|---|---|---|---|---|
| 0 | 1 | 0000 1101 = 13 | 13 | 13 |
| 1 | 1 | 0001 1010 = 26 | 26 | 39 |
| 2 | 0 | 0011 0100 = 52 | 0 (bỏ qua) | 39 |
| 3 | 1 | 0110 1000 = 104 | 104 | 143 |

Phần cứng làm mỗi chu kỳ một dòng của bảng trên. Thay vì dịch `a` i bit cùng lúc, thanh ghi `mcand` dịch trái 1 bit mỗi chu kỳ, nên ở chu kỳ thứ i `mcand` đã bằng `a` dịch i bit. Thanh ghi `mplier` chứa `b` và dịch phải 1 bit mỗi chu kỳ, nên bᵢ luôn nằm ở `mplier[0]`. Sau W chu kỳ, `acc` chứa tích.

## 2. Thông số

| Thông số | Giá trị |
|---|---|
| Độ rộng toán hạng | tham số `W`, mặc định 16 |
| Clock | `clk`, cạnh lên |
| Reset | `rst`, đồng bộ, mức cao; chỉ cần reset thanh ghi trạng thái |
| Độ trễ | `resp_valid` lên 1 sau W cạnh clock kể từ cạnh nhận yêu cầu (16 chu kỳ với W = 16) |
| Thông lượng | một phép nhân mỗi W + 2 chu kỳ khi `resp_ready` luôn bằng 1 |
| Số phép nhân cùng lúc | 1 |

## 3. Bảng cổng

| Cổng | Hướng | Độ rộng | Mô tả |
|---|---|---|---|
| `clk` | vào | 1 | clock |
| `rst` | vào | 1 | reset đồng bộ, mức cao |
| `req_valid` | vào | 1 | bên gửi có yêu cầu hợp lệ trên `a`, `b` |
| `req_ready` | ra | 1 | bộ nhân sẵn sàng nhận yêu cầu |
| `a` | vào | W | số bị nhân |
| `b` | vào | W | số nhân |
| `resp_valid` | ra | 1 | `p` đang chứa kết quả hợp lệ |
| `resp_ready` | vào | 1 | bên nhận sẵn sàng lấy kết quả |
| `p` | ra | 2W | tích `a × b` |

## 4. Giao thức valid/ready

- Một lần trao đổi xảy ra tại cạnh lên mà `valid` và `ready` cùng bằng 1.
- `req_ready = 1` chỉ khi bộ nhân rảnh (trạng thái IDLE).
- Bên gửi giữ nguyên `a`, `b` khi `req_valid = 1` mà `req_ready = 0`.
- Bộ nhân giữ nguyên `p` và `resp_valid = 1` cho đến khi `resp_ready = 1`.

Ví dụ W = 4, a = 13, b = 11 (p = 143 = 0x8f). Bên nhận chưa sẵn sàng ở chu kỳ 5:

| Chu kỳ | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|---|---|---|---|---|---|---|---|---|
| state | IDLE | CALC | CALC | CALC | CALC | DONE | DONE | IDLE |
| req_valid | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| req_ready | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
| cnt | – | 0 | 1 | 2 | 3 | – | – | – |
| mplier | – | 1011 | 0101 | 0010 | 0001 | – | – | – |
| acc | – | 0x00 | 0x0d | 0x27 | 0x27 | 0x8f | 0x8f | – |
| resp_valid | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 0 |
| resp_ready | 1 | 1 | 1 | 1 | 1 | 0 | 1 | 1 |

Trao đổi yêu cầu ở cạnh cuối chu kỳ 0; trao đổi kết quả ở cạnh cuối chu kỳ 6.

## 5. Bộ điều khiển (FSM)

| Trạng thái | Ý nghĩa | Ra | Chuyển sang |
|---|---|---|---|
| IDLE | chờ yêu cầu | `req_ready = 1` | CALC khi `req_valid = 1` |
| CALC | tính, mỗi chu kỳ một bit của b | – | DONE khi `cnt = W − 1` |
| DONE | giữ kết quả | `resp_valid = 1` | IDLE khi `resp_ready = 1` |

Reset đưa FSM về IDLE.

## 6. Datapath

| Thanh ghi | Độ rộng | Khi nhận yêu cầu (IDLE và req_valid) | Mỗi chu kỳ CALC |
|---|---|---|---|
| `acc` | 2W | 0 | cộng thêm `mcand` nếu `mplier[0] = 1` |
| `mcand` | 2W | `a` (mở rộng 0 lên 2W bit) | dịch trái 1 bit |
| `mplier` | W | `b` | dịch phải 1 bit |
| `cnt` | ⌈log2 W⌉ | 0 | tăng 1 |

`p` nối thẳng ra `acc`. Ở các trạng thái khác, các thanh ghi giữ nguyên.

## 7. Yêu cầu chấp nhận (cuối Lab 5)

- `make lint` không còn cảnh báo nào.
- `make sim` và `make sim-icarus` đều in PASS.
- Giá trị `acc` từng chu kỳ trong GTKWave của phép nhân 3 × 0x8001 (trường hợp thứ 6 của testbench) khớp với `make trace A=3 B=0x8001 W=16`.
- Không có latch (kiểm tra lại ở lab tổng hợp).

## 8. Lịch sử thay đổi

| Phiên bản | Ngày | Thay đổi |
|---|---|---|
| 1.0 | | Bản đầu |
