#!/usr/bin/env python3
# network_speed.py — prints "↓ {down} ↑ {up}" (human-readable).
# If you use Font Awesome in Waybar, you can replace DOWNLOAD_ICON/UPLOAD_ICON
# with '\uf019' and '\uf093' respectively (download/upload).

import time, os, sys, subprocess

# Icons: default to safe Unicode arrows. Swap for Font Awesome if you use it:
DOWNLOAD_ICON = "↓"  # safe default
UPLOAD_ICON = "↑"  # safe default
# Font Awesome alternatives (uncomment if your Waybar uses FA):
# DOWNLOAD_ICON = "\uf019"  # 
# UPLOAD_ICON   = "\uf093"  # 


def detect_iface():
    try:
        out = (
            subprocess.check_output(
                [
                    "/bin/sh",
                    "-c",
                    "ip route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i==\"dev\") print $(i+1); exit}'",
                ]
            )
            .decode()
            .strip()
        )
        if out:
            return out.splitlines()[0]
    except Exception:
        pass
    for ifn in os.listdir("/sys/class/net"):
        if ifn == "lo":
            continue
        if os.path.exists(f"/sys/class/net/{ifn}/statistics/rx_bytes"):
            return ifn
    return None


def read_bytes(iface):
    with open(f"/sys/class/net/{iface}/statistics/rx_bytes", "r") as f:
        rx = int(f.read().strip())
    with open(f"/sys/class/net/{iface}/statistics/tx_bytes", "r") as f:
        tx = int(f.read().strip())
    return rx, tx


def human(n):
    for unit in ["B/s", "KiB/s", "MiB/s", "GiB/s"]:
        if n < 1024 or unit == "GiB/s":
            return f"{n:.1f} {unit}"
        n /= 1024.0


def main():
    iface = detect_iface()
    if not iface:
        print("no iface")
        sys.exit(1)
    rx0, tx0 = read_bytes(iface)
    time.sleep(1)
    rx1, tx1 = read_bytes(iface)
    down = max(0, rx1 - rx0)
    up = max(0, tx1 - tx0)
    print(f"{DOWNLOAD_ICON} {human(down)}  {UPLOAD_ICON} {human(up)}")


if __name__ == "__main__":
    main()
