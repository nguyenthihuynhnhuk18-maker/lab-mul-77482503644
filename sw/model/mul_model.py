#!/usr/bin/env python3
"""Mo hinh chu ky cua bo nhan dich-va-cong (dac ta doc/dac-ta.md).

In bang tung chu ky trang thai CALC de doi chieu voi bang tinh tay
va voi dang song GTKWave.

    python3 sw/model/mul_model.py 13 11 --w 4
    python3 sw/model/mul_model.py 0x1234 0xabcd --w 16
"""
import argparse


def mul_trace(a, b, w):
    """Tra ve (tich, danh sach dong trace) theo dung thuat toan cua RTL."""
    mask2 = (1 << (2 * w)) - 1
    acc, mcand, mplier = 0, a, b
    rows = []
    for cnt in range(w):
        add = mplier & 1
        acc_new = (acc + mcand) & mask2 if add else acc
        rows.append((cnt, mplier, mcand, add, acc, acc_new))
        acc = acc_new
        mcand = (mcand << 1) & mask2
        mplier >>= 1
    return acc, rows


def main():
    ap = argparse.ArgumentParser(description="Trace bo nhan dich-va-cong")
    ap.add_argument("a", type=lambda s: int(s, 0))
    ap.add_argument("b", type=lambda s: int(s, 0))
    ap.add_argument("--w", type=int, default=16, help="do rong W (mac dinh 16)")
    args = ap.parse_args()
    w = args.w
    if not (0 <= args.a < 2 ** w and 0 <= args.b < 2 ** w):
        ap.error(f"a va b phai nam trong 0..{2 ** w - 1}")

    p, rows = mul_trace(args.a, args.b, w)
    hw = (2 * w + 3) // 4
    print(f"W={w}  a={args.a}  b={args.b}")
    print(f"{'cnt':>3}  {'mplier':>{w}}  {'mcand':>{hw + 2}}  cong?  {'acc truoc':>{hw + 2}}  {'acc sau':>{hw + 2}}")
    for cnt, mplier, mcand, add, acc, acc_new in rows:
        print(f"{cnt:>3}  {mplier:0{w}b}  0x{mcand:0{hw}x}  {'co ' if add else 'khong':5}  0x{acc:0{hw}x}  0x{acc_new:0{hw}x}")
    print(f"Ket qua p = {p} (0x{p:0{hw}x}); a*b = {args.a * args.b} -> {'DUNG' if p == args.a * args.b else 'SAI'}")


if __name__ == "__main__":
    main()
