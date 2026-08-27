# TECNO MegaPad 11 (T1101) — OrangeFox Recovery Device Tree

**Device:** TECNO MegaPad 11 / T1101 ("Pad 6")
**Codename:** `koto`
**Product:** `miflower_global`
**SoC:** MediaTek MT6789 (Helio G99) — boots as hardware id `mt8781`
**Android:** 14 (SDK 34), A/B **virtual**, **vendor_boot-as-recovery** (boot header v4)
**Kernel:** prebuilt from stock firmware `boot.img` (`gf82f736`), NOT built from source

This tree builds **OrangeFox recovery** packaged as `vendor_boot.img` (the device has
no dedicated `recovery` partition; recovery lives inside `vendor_boot`).

## Layout

```
BoardConfig.mk            Build settings (offsets, sizes, header v4, prebuilt DTB)
Android.mk                Only includes sub-makefiles for TARGET_DEVICE=koto
AndroidProducts.mk        lunch target twrp_koto-eng
twrp_koto.mk              Product config (inherits OF common.mk + device.mk)
device.mk                 HALs, bootctrl, mtk_plpath_utils, ramdisk copies
system.prop               Build system properties
vendorsetup.sh            OrangeFox build vars (FOX_VENDOR_BOOT_RECOVERY etc.)
fox_koto                  OrangeFox build vars file
recovery.fstab            TWRP filesystem tab
prebuilt/dtb.img          Stock MTK dtb (209723 bytes, BOARD_DTB_SIZE)
bootctrl/                 MTK boot control HAL (slot switching)
mtk_plpath_utils/         MTK post-install path util (OTA)
recovery/root/            Vendor/recovery ramdisk payload:
  first_stage_ramdisk/    fstab.mt6789 / fstab.mt8781 / fstab.emmc
  init.recovery.mt6789.rc / init.recovery.mt8781.rc / init.recovery.usb.rc
  ueventd.mt6789.rc / ueventd.mt8781.rc
  lib/modules/            207 stock factory kernel modules + modules.load(.recovery)
```

## Kernel modules (touch!)

All 207 stock factory kernel modules (taken from the firmware's recovery ramdisk /
`vendor_dlkm`) are shipped under `recovery/root/lib/modules/` and auto-bundled by
the recovery build, loaded via `modules.load.recovery`. Critically this includes the
**touch** drivers used with the prebuilt `gf82f736` recovery kernel:

- `chipone_icnl9951r.ko` (606240 B) — primary touch controller
- `adaptive-ts.ko` (156656 B)
- `jadard_touch.ko` (549096 B)
- display: `mtk_panel_ext.ko`, `icnl9951r_fhd_dsi_vdo_hjr_hkc_90hz_x1101.ko`, `mediatek-drm.ko`, `mediatek-drm-gateic.ko`

These were verified to load as `Live` on the running `gf82f736` kernel on-device
(`lsmod` showed `chipone_icnl9951r`, `adaptive_ts`, `jadard_touch` loaded with a
**working touchscreen**). MTK kernels tolerate the `-dirty` vermagic suffix
difference, so this module set is the correct one for the recovery kernel.

## BoardConfig highlights

- `TARGET_PREBUILT_DTB` only — kernel is **not** packed (GKI/vendor_boot,
  `TARGET_NO_KERNEL=true`; the actual kernel is the device's own `boot.img`)
- `BOARD_BOOT_HEADER_VERSION := 4`, `BOARD_HEADER_SIZE := 2128`
- `BOARD_DTB_SIZE := 209723`, `BOARD_DTB_OFFSET := 0x47c80000`
- `BOARD_VENDOR_CMDLINE := bootopt=64S3,32N2,64N2`
- `BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true`
- `BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true`
- page 4096, base 0x3fff8000, kernel/ramdisk/tags offset 0x47c80000

## Building (OrangeFox-Action-Builder cloud)

Push this tree to GitHub (branch `fox_12.1`), then in
`niels-space/tecno-t1101-OrangeFox-Action-Builder` (or a fork) run the workflow with:

| Input | Value |
|-------|-------|
| `MANIFEST_BRANCH` | `12.1` |
| `DEVICE_TREE` | `YOUR_USER/YOUR_DEVICE_TREE_REPO` |
| `DEVICE_TREE_BRANCH` | `fox_12.1` |
| `DEVICE_PATH` | `device/tecno/koto` |
| `DEVICE_NAME` | `koto` |
| `BUILD_TARGET` | `vendorboot` |

Output: a freshly built `vendor_boot.img` with a working touchscreen.

> **Flash only with explicit approval.** The build image replaces the device's
> `vendor_boot`. Verify with `fastboot`/`adb` that the stock recovery path is
> intact before flashing.
