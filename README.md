# luci-theme-sophos

Sophos Firewall inspired visual theme for OpenWrt LuCI.

> Independent community theme. Not affiliated with, endorsed by, or sponsored by Sophos Limited.

## Structure

```text
luci-theme-sophos/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   └── feature_request.md
│   └── workflows/
│       ├── build.yml
│       └── release.yml
├── htdocs/luci-static/sophos/
│   ├── cascade.css
│   └── menu-sophos.js
├── root/etc/uci-defaults/luci-theme-sophos
├── ucode/template/themes/sophos/
│   ├── header.ut
│   └── footer.ut
├── .gitattributes
├── .gitignore
├── CHANGELOG.md
├── CONTRIBUTING.md
├── DEVELOPMENT.md
├── LICENSE
├── Makefile
└── README.md
```

The layout follows the LuCI module structure: `htdocs` is installed below the
web root, `root` is copied to the target filesystem, and modern themes provide
uCode templates under `ucode/template/themes/<theme>/`.

## Build

Clone OpenWrt and copy this repository into the LuCI feed:

```sh
git clone https://github.com/openwrt/openwrt.git
cd openwrt
./scripts/feeds update luci
mkdir -p feeds/luci/themes/luci-theme-sophos
cp -a /path/to/luci-theme-sophos/Makefile /path/to/luci-theme-sophos/ucode \
      /path/to/luci-theme-sophos/htdocs /path/to/luci-theme-sophos/root \
      feeds/luci/themes/luci-theme-sophos/
./scripts/feeds install luci-theme-sophos
make menuconfig
```

Select `LuCI -> Themes -> luci-theme-sophos`, then:

```sh
make package/luci-theme-sophos/compile V=s
```

The package is generated below `bin/packages/*/luci/`.

## Install

On classic `opkg` based systems:

```sh
opkg install luci-theme-sophos_*.ipk
```

Then select:

`System -> System -> Language and Style -> Design -> Sophos`

## GitHub release

```sh
git tag v1.0.0
git push origin v1.0.0
```

The release workflow builds the IPK and attaches it to the GitHub Release.

## Roadmap

- 1.0: Sophos-style shell, sidebar, header, forms, tables and responsive layout.
- 1.1: Dedicated dashboard with CPU/RAM/load, WAN/LAN/VLAN and traffic cards.
- 1.2: Enhanced firewall, connection/session and VPN presentation.

## License

Apache License 2.0.
