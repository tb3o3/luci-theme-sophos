# luci-theme-sophos

![OpenWrt](https://img.shields.io/badge/OpenWrt-LuCI-00A8E8)
![License](https://img.shields.io/badge/license-Apache--2.0-blue)
![Version](https://img.shields.io/badge/version-1.0.0-green)

A **Sophos Firewall inspired** visual theme for OpenWrt LuCI.

> Independent community theme. Not affiliated with, endorsed by, or sponsored by Sophos Limited.

## Contents

- [Important: where to run commands](#important-where-to-run-commands)
- [Build an IPK on a generic Linux computer](#build-an-ipk-on-a-generic-linux-computer)
- [Build the package](#build-the-package)
- [Install the IPK on the OpenWrt router](#install-the-ipk-on-the-openwrt-router)
- [Build using GitHub Actions](#build-using-github-actions)
- [Create a local OpenWrt feed](#create-a-local-openwrt-feed)
- [Repository layout](#repository-layout)
- [Troubleshooting](#troubleshooting)

## Important: where to run commands

**Build the `.ipk` on a Linux build machine, not on the OpenWrt router.** The build machine can be a physical PC, a virtual machine, or a Linux server. A normal Debian/Ubuntu installation is suitable. The OpenWrt router is the target where you install the finished package; it does not normally need the compiler or the OpenWrt buildroot.

The recommended method is to use the official **OpenWrt build system** on the Linux computer. Even though this theme is mostly CSS, JavaScript and templates, using the build system ensures the package layout and metadata are generated in the format expected by LuCI. See the official [OpenWrt build-system guide](https://openwrt.org/docs/guide-developer/toolchain/use-buildsystem) and [single-package build guide](https://openwrt.org/docs/guide-developer/toolchain/single.package).

Do not run `make package/luci-theme-sophos/compile` directly on the router or in an arbitrary directory: that command must be run from the root of a prepared OpenWrt buildroot.

## Build an IPK on a generic Linux computer

These steps are for a Debian/Ubuntu Linux computer (or a Linux VM). They do not run on the OpenWrt router.

### 1. Install the host dependencies

Open a terminal on the Linux build computer:

```sh
sudo apt update
sudo apt install -y build-essential clang flex bison g++ gawk \
  gcc-multilib g++-multilib gettext git libncurses-dev libssl-dev \
  python3-setuptools rsync swig unzip zlib1g-dev file wget python3
```

OpenWrt recommends building as a normal user, not as `root`, and using a case-sensitive filesystem. Avoid spaces in the build directory path.

### 2. Download the OpenWrt buildroot

```sh
mkdir -p ~/src
cd ~/src
git clone https://github.com/openwrt/openwrt.git
cd openwrt
```

**Version matching:** for best compatibility, build against the OpenWrt release/branch running on your router, rather than automatically using `main`. For example, if your router runs a stable release, check out the corresponding release branch/tag before continuing. You can check the router version in LuCI under **Status → Overview** or with `ubus call system board` on the router.

Example only (replace the branch with the one matching your router):

```sh
git branch -a | grep openwrt-
git checkout openwrt-<release>
```

If you change branch after the initial clone, continue with the feed setup below.

### 3. Prepare the LuCI feed

Run these commands from the **OpenWrt buildroot directory** (`~/src/openwrt`):

```sh
./scripts/feeds update luci
./scripts/feeds install luci-base
```

### 4. Copy this repository into the LuCI feed

First download or clone this `luci-theme-sophos` GitHub repository on the Linux build computer. For example, in a second terminal:

```sh
cd ~/src
git clone https://github.com/<YOUR-USERNAME>/luci-theme-sophos.git
```

Replace `<YOUR-USERNAME>` with your GitHub username. If you downloaded the repository ZIP instead, extract it and use the extracted directory in place of `~/src/luci-theme-sophos`.

Then, from the OpenWrt buildroot (`~/src/openwrt`), copy the package files into the LuCI feed:

```sh
mkdir -p feeds/luci/themes/luci-theme-sophos
cp -a ~/src/luci-theme-sophos/Makefile \
      ~/src/luci-theme-sophos/ucode \
      ~/src/luci-theme-sophos/htdocs \
      ~/src/luci-theme-sophos/root \
      feeds/luci/themes/luci-theme-sophos/
```

If your repository was extracted into a different directory, adjust the source path in the `cp` command.

Register the package with the build system:

```sh
./scripts/feeds install luci-theme-sophos
```

### 5. Enable the package

Still from `~/src/openwrt`, run:

```sh
make menuconfig
```

Find the package under the LuCI themes section and enable `luci-theme-sophos` as a module (`<M>`) or built-in (`<*>`), depending on the options shown by that OpenWrt branch. Save and exit.

For a package-only build, you do not need to build a complete firmware image, but the buildroot must be configured and its host tools/toolchain prepared. The build system will request the necessary prerequisites as appropriate.

### 6. Build the IPK

Run from the **root of the OpenWrt buildroot**, not from the theme repository and not from the router:

```sh
make package/luci-theme-sophos/compile V=s
```

When the build succeeds, locate the package with:

```sh
find bin -type f \( -name 'luci-theme-sophos_*.ipk' -o -name 'luci-theme-sophos_*.apk' \)
```

Depending on the OpenWrt version and package manager, the build may produce an `.ipk` or `.apk`. Use the format and package manager supported by your router. The resulting package is usually under `bin/packages/.../luci/`.

Copy the generated package to a safe location on your computer. You can then transfer it to the router with `scp` (replace the IP address and file name as needed):

```sh
scp bin/packages/*/luci/luci-theme-sophos_* root@192.168.1.1:/tmp/
```

If the wildcard matches more than one file, specify the exact package filename instead.

## Build the package

The package is built using OpenWrt's `luci.mk` build rules. The build system collects the files from `htdocs/`, `root/` and `ucode/`, then creates package metadata and the installable package. Do **not** try to make an IPK by simply zipping the repository or by running `make` in the theme directory alone.

Official references:

- [OpenWrt build system usage](https://openwrt.org/docs/guide-developer/toolchain/use-buildsystem)
- [Building a single package](https://openwrt.org/docs/guide-developer/toolchain/single.package)
- [LuCI module authoring](https://github.com/openwrt/luci/blob/master/doc_gen/tutorials/Modules.md)
- [LuCI package build rules (`luci.mk`)](https://github.com/openwrt/luci/blob/master/luci.mk)

## Install the IPK on the OpenWrt router

The following commands are run **on the OpenWrt router**, after you have built and copied the package to `/tmp/`.

### On an `opkg`-based OpenWrt release

SSH into the router, then install the exact file name:

```sh
opkg install /tmp/luci-theme-sophos_<version>_all.ipk
```

### On an `apk`-based OpenWrt release

Recent OpenWrt versions may use `apk` instead of `opkg`. Use the package format produced for that release and follow its package manager's syntax. For a locally copied APK, the command is generally:

```sh
apk add --allow-untrusted /tmp/luci-theme-sophos_<version>_all.apk
```

Do not run both commands; use the package manager installed on your router. Avoid `--force-depends` unless you understand the dependency issue it is bypassing.

After installation, open LuCI and select **System → System → Language and Style → Design → Sophos** (the exact wording may vary slightly by LuCI version). Save and apply.

The theme registers itself but does not force itself to become the active theme during installation.

## Build using GitHub Actions

The repository includes workflows under `.github/workflows/`:

- `build.yml` runs on pushes, pull requests and manual dispatches and uploads the build output as a workflow artifact.
- `release.yml` runs when a `v*` tag is pushed and attempts to attach the package to a GitHub Release.

To create a release:

```sh
git tag v1.0.0
git push origin v1.0.0
```

**Important:** check that the workflow's OpenWrt branch matches the release you want to support. For a public project, pin the OpenWrt branch/tag and review the Actions log before distributing packages. GitHub Actions builds on a Linux runner; it does not build on your router.

## Create a local OpenWrt feed

If you maintain your own OpenWrt buildroot and want to keep the theme outside the main LuCI feed, you can add a local feed. This is optional; the copy-into-`feeds/luci/themes` method above is simpler for a first build.

For a repeatable local feed, define a `src-link` entry in `feeds.conf` pointing to a local feed directory, place the package under `themes/luci-theme-sophos/`, then run `./scripts/feeds update <feed-name>` and `./scripts/feeds install luci-theme-sophos` from the OpenWrt buildroot. See the [LuCI module documentation](https://github.com/openwrt/luci/blob/master/applications/luci-app-example/BUILDING.md) for the feed setup pattern.

## Repository layout

```text
luci-theme-sophos/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   └── workflows/
├── htdocs/luci-static/sophos/
│   ├── cascade.css
│   └── menu-sophos.js
├── root/etc/uci-defaults/
├── ucode/template/themes/sophos/
│   ├── header.ut
│   └── footer.ut
├── scripts/
├── .gitattributes
├── .gitignore
├── CHANGELOG.md
├── CONTRIBUTING.md
├── DEVELOPMENT.md
├── LICENSE
├── Makefile
└── README.md
```

## Troubleshooting

- **`make: *** No rule to make target 'package/luci-theme-sophos/compile'`**: check that you are in the OpenWrt buildroot, the package was copied to `feeds/luci/themes/luci-theme-sophos`, and `./scripts/feeds install luci-theme-sophos` completed successfully.
- **The package is not found after building**: use `find bin -name 'luci-theme-sophos_*'` and check the build log for errors.
- **Package manager or format mismatch**: build against the OpenWrt release running on the router and use its supported package format (`.ipk`/`opkg` or `.apk`/`apk`).
- **Theme does not appear in the Design list**: confirm the package installed successfully, check `/etc/uci-defaults/` and `/www/luci-static/sophos/`, then clear the browser cache or reload LuCI.
- **Need to revert**: use LuCI's Design selector to choose the previous theme. Keep an SSH session available while testing a new theme.

## Roadmap

### 1.0
- Sophos-inspired shell, sidebar and header
- Styled LuCI forms, tables and alerts
- Responsive layout

### 1.1
- Dedicated Sophos-style dashboard
- CPU/RAM/load widgets
- WAN/LAN/VLAN status cards
- Traffic overview

### 1.2
- Improved firewall rule presentation
- Connection/session counters
- VPN status cards
- More SFOS-like navigation groups

## License

Apache License 2.0. This independent project does not contain Sophos proprietary software, source code or artwork.