#
# Copyright (C) 2026 The OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

# API - 12.1 TWRP/OF branch compatibility
PRODUCT_SHIPPING_API_LEVEL := 32
PRODUCT_TARGET_VNDK_VERSION := 32

# A/B (virtual)
ENABLE_VIRTUAL_AB := true
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# SDCard replacement functionality
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

AB_OTA_UPDATER := true
AB_OTA_PARTITIONS := \
    boot \
    dtbo \
    init_boot \
    lk \
    logo \
    md1img \
    vendor_boot \
    vendor_dlkm \
    odm_dlkm

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier \
    checkpoint_gc

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/mtk_plpath_utils \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

# Boot control HAL (MTK)
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-mtkimpl \
    android.hardware.boot@1.2-mtkimpl.recovery

PRODUCT_PACKAGES_DEBUG += \
    bootctrl

# MTK plpath utils
PRODUCT_PACKAGES += \
    mtk_plpath_utils \
    mtk_plpath_utils.recovery

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service

# Drm
PRODUCT_PACKAGES += \
    android.hardware.drm@1.4

# Keymaster (MTK keymaster 4.x)
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.1

TARGET_RECOVERY_DEVICE_MODULES += \
    android.hardware.keymaster@4.1

TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.keymaster@4.1.so

# Keystore2
PRODUCT_PACKAGES += \
    android.system.keystore2

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)

# ---- Recovery ramdisk: vendor_boot-as-recovery (boot header v4) ----
# Stock T1101 ships BOTH mt6789 and mt8781 fstab/init variants; the
# bootloader selects one (ro.boot.hardware). Package both.
PRODUCT_COPY_FILES += \
    device/tecno/koto/recovery/root/init.recovery.mt6789.rc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/init.recovery.mt6789.rc \
    device/tecno/koto/recovery/root/init.recovery.mt8781.rc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/init.recovery.mt8781.rc \
    device/tecno/koto/recovery/root/ueventd.mt6789.rc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/ueventd.mt6789.rc \
    device/tecno/koto/recovery/root/ueventd.mt8781.rc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/ueventd.mt8781.rc \
    device/tecno/koto/recovery/root/first_stage_ramdisk/fstab.mt6789:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt6789 \
    device/tecno/koto/recovery/root/first_stage_ramdisk/fstab.mt8781:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt8781 \
    device/tecno/koto/recovery/root/first_stage_ramdisk/fstab.emmc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.emmc

# ---- Kernel modules (touch, display, storage, etc.) ----
# The full stock factory module set (incl. touch: chipone_icnl9951r,
# adaptive-ts, jadard_touch, display panels) is placed under
# recovery/root/lib/modules/ along with modules.load and
# modules.load.recovery. The recovery build system auto-bundles these into
# the recovery/vendor ramdisk (no explicit PRODUCT_COPY_FILES needed) and
# loads them on boot. Modules are prebuilt for the gf82f736 recovery kernel,
# matching the stock recovery; they are NOT built from source here.
