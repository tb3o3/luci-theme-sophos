#!/bin/sh
set -eu
OPENWRT_DIR="${1:-../openwrt}"
DEST="$OPENWRT_DIR/feeds/luci/themes/luci-theme-sophos"
[ -d "$OPENWRT_DIR" ] || { echo "OpenWrt buildroot not found: $OPENWRT_DIR" >&2; exit 1; }
mkdir -p "$DEST"
cp -a Makefile ucode htdocs root "$DEST/"
echo "Theme copied to $DEST"
echo "Next: cd $OPENWRT_DIR && ./scripts/feeds install luci-theme-sophos && make menuconfig"
