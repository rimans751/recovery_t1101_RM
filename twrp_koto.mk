#
# Copyright (C) 2026 The OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

# GSI keys (developer GSI boot with verified boot)
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)

# OrangeFox common config
$(call inherit-product, vendor/twrp/config/common.mk)

# Device specific configs.
$(call inherit-product, device/tecno/koto/device.mk)

# Device identifier. This must come after all inclusions
PRODUCT_DEVICE := koto
PRODUCT_NAME := twrp_koto
PRODUCT_BRAND := TECNO
PRODUCT_MODEL := T1101
PRODUCT_MANUFACTURER := TECNO
PRODUCT_RELEASE_NAME := MegaPad 11
