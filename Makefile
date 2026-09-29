include $(TOPDIR)/rules.mk

LUCI_TITLE:=Sophos Style Theme for LuCI
LUCI_DESCRIPTION:=Sophos Firewall inspired enterprise-style theme for OpenWrt LuCI
LUCI_DEPENDS:=+luci-base
LUCI_PKGARCH:=all

PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=luci-theme-sophos contributors
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
