#
# Copyright (C) 2026 The OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#
# TECNO MegaPad 11 (T1101) / codename: koto / product: miflower_global
# MediaTek MT6789 (Helio G99) / board identifier mt8781
# Android 14 (SDK 34), A/B, vendor_boot-as-recovery (boot header v4)
#

DEVICE_PATH := device/tecno/koto

# Build Hack
BUILD_BROKEN_DUP_RULES := true
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a76

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a55

TARGET_USES_64_BIT_BINDER := true
TARGET_SUPPORTS_32_BIT_APPS := true
TARGET_SUPPORTS_64_BIT_APPS := true
ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true

# Assertion
# Several identifiers are used for the same physical tablet
TARGET_OTA_ASSERT_DEVICE := koto,miflower_global,T1101,TECNOT1101

# Bootloader
# MTK uses a board-independent preloader; TWRP does not need a bootloader name
TARGET_BOOTLOADER_BOARD_NAME := k6789v1_64
TARGET_NO_BOOTLOADER := true

# Platform
TARGET_BOARD_PLATFORM := mt6789

# Boot hardware (kernel DT board id) - stock loads mt6789/mt8781
BOARD_VENDOR_KERNEL_DTS := mt6789 mt8781

# API level - Android 14 (SDK 34), 12.1 TWRP/OF branch compatibility
BOARD_SHIPPING_API_LEVEL := 32
PRODUCT_SHIPPING_API_LEVEL := 32

# Kernel - prebuilt DTB from original TECNO firmware boot.img (gf82f736)
# The device is GKI/vendor_boot: the kernel lives in boot.img, not the
# recovery image (TARGET_NO_KERNEL). Only the DTB is packed into vendor_boot.
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img

# Vendor cmdline + bootconfig confirmed from stock vendor_boot header
BOARD_VENDOR_CMDLINE := bootopt=64S3,32N2,64N2
BOARD_KERNEL_BASE := 0x3fff8000
BOARD_PAGE_SIZE := 4096
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x47c80000
BOARD_TAGS_OFFSET := 0x47c80000
BOARD_BOOT_HEADER_VERSION := 4
BOARD_HEADER_SIZE := 2128
# Stock/firmware DTB size confirmed: 209723 bytes
BOARD_DTB_SIZE := 209723
BOARD_DTB_OFFSET := 0x47c80000
BOARD_FLASH_BLOCK_SIZE := 262144

BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)
BOARD_MKBOOTIMG_ARGS += --vendor_cmdline "$(BOARD_VENDOR_CMDLINE)"
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_PAGE_SIZE) --board ""
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)

BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_RAMDISK_USE_LZ4 := true
TARGET_NO_KERNEL := true

# AVB
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

# Partitions - sizes from original firmware images
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864         # boot.img (64MB)
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864  # vendor_boot.img (64MB)
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 8388608    # init_boot.img
BOARD_DTBOIMAGE_PARTITION_SIZE := 8388608          # dtbo.img

# Super - logical dynamic partitions
BOARD_SUPER_PARTITION_SIZE := 5370966752
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_PARTITION_LIST := system system_ext product vendor vendor_dlkm odm odm_dlkm tr_mi tr_theme tr_region tr_company tr_carrier tr_product tr_preload
BOARD_MAIN_SIZE := 5363466240 # super - 7MiB

BOARD_PARTITION_LIST := $(call to-upper, $(BOARD_MAIN_PARTITION_LIST))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := erofs))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))

BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Properties
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop

# System as root
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false

# Display - tablet 1200x1920, density 225 (physical) ~213 (mdpi theme)
TARGET_SCREEN_HEIGHT := 1920
TARGET_SCREEN_WIDTH := 1200
TARGET_SCREEN_DENSITY := 225

# Recovery
TARGET_NO_RECOVERY := true
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_HAS_NO_SELECT_BUTTON := true
BOARD_SUPPRESS_SECURE_ERASE := true
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab

# Storage
TW_INTERNAL_STORAGE_PATH := "/data/media/0"
TW_INTERNAL_STORAGE_MOUNT_POINT := "data"
TW_EXTERNAL_STORAGE_PATH := "/external_sd"
TW_EXTERNAL_STORAGE_MOUNT_POINT := "external_sd"
TW_HAS_NO_RECOVERY_PARTITION := true
TW_BACKUP_DATA_MEDIA := true

# USB - MTK musb controller (confirmed from stock recovery init)
TARGET_USE_CUSTOM_LUN_FILE_PATH := "/config/usb_gadget/g1/functions/mass_storage.usb0/lun.%d/file"
TW_USB_STORAGE := false

# Debug
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true

# Crypto
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
BOARD_USES_METADATA_PARTITION := true

# Android 14 (SDK 34)
PLATFORM_VERSION := 14
PLATFORM_VERSION_LAST_STABLE := 14
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := 2099-12-31

# Tools
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_REPACKTOOLS := true

# TWRP / OrangeFox compatible flags
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TW_MAX_BRIGHTNESS := 250
TW_DEFAULT_BRIGHTNESS := 200

# Flashlight (Torch) - tablet has a single LED camera-flash
OFOX_FLASHLIGHT_ENABLE := true
TW_DEFAULT_TORCH_PATH := "/sys/class/leds/flashlight/brightness"
TW_MAX_TORCH_BRIGHTNESS := 1
TW_STATUS_ICONS_ALIGN := center
TW_STATUSBAR_RIGHT_PADDING := 40
TW_STATUSBAR_LEFT_PADDING := 40
TW_THEME := landscape_hdpi
TW_NO_SCREEN_BLANK := true
TW_INCLUDE_FASTBOOTD := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_EXCLUDE_APEX := true
TW_INCLUDE_NTFS_3G := true
TARGET_USES_MKE2FS := true
TW_INCLUDE_FUSE_EXFAT := true
TW_EXTRA_LANGUAGES := true
TW_DEFAULT_LANGUAGE := en
TW_CUSTOM_CPU_TEMP_PATH := /sys/class/thermal/thermal_zone0/temp

# Haptics
TW_CUSTOM_VIBRATOR_PATH := /sys/class/leds/vibrator/brightness
