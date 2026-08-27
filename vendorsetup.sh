#
# TECNO MegaPad 11 (T1101) - koto - OrangeFox Recovery
# Copyright (C) 2026 The OrangeFox Recovery Project
# SPDX-License-Identifier: Apache-2.0
#
FDEVICE="koto"

fox_get_target_device() {
	if echo "$BASH_SOURCE" | grep -q "/$FDEVICE/"; then
		FOX_BUILD_DEVICE="$FDEVICE";
	elif set | grep BASH_ARGV | grep -w \"$FDEVICE\"; then
		FOX_BUILD_DEVICE="$FDEVICE";
	elif echo "${BASH_SOURCE[0]}" | grep -q "/$FDEVICE/"; then
		FOX_BUILD_DEVICE="$FDEVICE";
	elif echo "$0" | grep -q "$FDEVICE"; then
		FOX_BUILD_DEVICE="$FDEVICE";
	fi
}

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" ]; then
	fox_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then

	# ===== Device Type =====
	# Virtual A/B device
	export FOX_VIRTUAL_AB_DEVICE=1
	export FOX_AB_DEVICE=1

	# vendor_boot-as-recovery (boot header v4, no dedicated recovery partition)
	export FOX_VENDOR_BOOT_RECOVERY=1

	# Non-Xiaomi device
	export FOX_VANILLA_BUILD=1

	# ===== Kernel =====
	# Using prebuilt kernel/modules - avoid "NO KERNEL CONFIG" error
	export OF_FORCE_PREBUILT_KERNEL=1

	# ===== Decryption =====
	export OF_DEFAULT_KEYMASTER_VERSION=4.1

	# ===== Display =====
	# Tablet 1200x1920 (16:10), density 225
	export OF_SCREEN_H=1920
	export OF_SCREEN_W=1200
	export OF_ALLOW_DISABLE_NAVBAR=1
	export OF_STATUS_H=65

	# ===== Partitions / Mounting =====
	export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/mapper/system"
	export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/mapper/vendor"

	# ===== Shell & Utilities =====
	export FOX_USE_BASH_SHELL=1
	export FOX_ASH_IS_BASH=1
	export FOX_USE_TAR_BINARY=1
	export FOX_USE_LZ4_BINARY=1
	export FOX_USE_ZSTD_BINARY=1
	export FOX_USE_XZ_UTILS=1
	export FOX_USE_DATE_BINARY=1
	export FOX_USE_BUSYBOX_BINARY=1
	export FOX_USE_SED_BINARY=1

	# ===== OrangeFox Features =====
	export FOX_DELETE_AROMAFM=1
	export FOX_ENABLE_APP_MANAGER=1
	export FOX_REPLACE_TOOLBOX_GETPROP=1

	# ===== Timezone =====
	export OF_DEFAULT_TIMEZONE="GMT-0"

	# ===== Maintainer =====
	export OF_MAINTAINER="T1101"

	# ===== Storage Paths =====
	export FOX_SETTINGS_ROOT_DIRECTORY=/data/recovery
	export FOX_MISCELLANEOUS_ROOT_DIRECTORY=/sdcard

else
	if [ -z "$FOX_BUILD_DEVICE" -a -z "$BASH_SOURCE" ]; then
		echo "I: This script requires bash. Not processing the $FDEVICE $(basename $0)"
	fi
fi
#
