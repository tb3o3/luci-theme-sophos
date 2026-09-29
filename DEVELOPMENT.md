# Development notes

The current LuCI build system supports uCode templates and optional
precompilation/minification through `luci.mk`.

Theme-specific code belongs in:

- `ucode/template/themes/sophos/*.ut` — page shell
- `htdocs/luci-static/sophos/` — CSS, JavaScript and assets
- `root/etc/uci-defaults/` — installation-time registration

Avoid hard-coding application routes in the theme. Installed LuCI menu
definitions remain the source of truth.

Test against the LuCI feed belonging to the OpenWrt release being targeted.
Avoid mixing packages from unrelated LuCI branches.
