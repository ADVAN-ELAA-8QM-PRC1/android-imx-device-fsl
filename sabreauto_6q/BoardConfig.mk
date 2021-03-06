#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
include device/fsl/sabreauto_6q/build_id.mk
include device/fsl/imx6/BoardConfigCommon.mk
ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include device/fsl-codec/fsl-codec.mk
endif
# sabreauto_6dq default target for EXT4
BUILD_TARGET_FS ?= ext4
include device/fsl/imx6/imx6_target_fs.mk

ifeq ($(BUILD_TARGET_FS),ubifs)
TARGET_RECOVERY_FSTAB = device/fsl/sabreauto_6q/fstab_nand.freescale
# build ubifs for nand devices
PRODUCT_COPY_FILES +=	\
	device/fsl/sabreauto_6q/fstab_nand.freescale:root/fstab.freescale
else
ifneq ($(BUILD_TARGET_FS),f2fs)
TARGET_RECOVERY_FSTAB = device/fsl/sabreauto_6q/fstab.freescale
# build for ext4
PRODUCT_COPY_FILES +=	\
	device/fsl/sabreauto_6q/fstab.freescale:root/fstab.freescale
else
TARGET_RECOVERY_FSTAB = device/fsl/sabreauto_6q/fstab-f2fs.freescale
# build for f2fs
PRODUCT_COPY_FILES +=	\
	device/fsl/sabreauto_6q/fstab-f2fs.freescale:root/fstab.freescale
endif # BUILD_TARGET_FS
# Support gpt
BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-7GB.bpt
ADDITION_BPT_PARTITION = partition-table-14GB:device/fsl/common/partition/device-partitions-14GB.bpt \
                         partition-table-28GB:device/fsl/common/partition/device-partitions-28GB.bpt

endif # BUILD_TARGET_FS

# Vendor Interface Manifest
PRODUCT_COPY_FILES += \
    device/fsl/sabreauto_6q/manifest.xml:vendor/manifest.xml

TARGET_BOOTLOADER_BOARD_NAME := SABREAUTO

PRODUCT_MODEL := SABREAUTO-MX6Q

TARGET_BOOTLOADER_POSTFIX := imx
TARGET_DTB_POSTFIX := -dtb

USE_OPENGL_RENDERER := true
TARGET_CPU_SMP := true

TARGET_RELEASETOOLS_EXTENSIONS := device/fsl/imx6

BOARD_WLAN_DEVICE            := bcmdhd
WPA_SUPPLICANT_VERSION       := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

PHONE_MODULE_INCLUDE := flase
#for accelerator sensor, need to define sensor type here
BOARD_HAS_SENSOR := true
SENSOR_MMA8451 := true

# for recovery service
TARGET_SELECT_KEY := 28
# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
DM_VERITY_RUNTIME_CONFIG := true

# camera hal v3
IMX_CAMERA_HAL_V3 := true

BOARD_HAVE_USB_CAMERA := true

USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

BOARD_KERNEL_CMDLINE := console=ttymxc3,115200 init=/init video=mxcfb0:dev=ldb,fbpix=RGB32,bpp=32 video=mxcfb1:off video=mxcfb2:off video=mxcfb3:off vmalloc=128M androidboot.console=ttymxc3 consoleblank=0 androidboot.hardware=freescale cma=512M galcore.contiguousSize=67108864

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
#UBI boot command line.
UBI_ROOT_INI := device/fsl/sabreauto_6q/ubi/ubinize.ini
TARGET_MKUBIFS_ARGS := -m 8192 -e 1032192 -c 4096 -x none -F
TARGET_UBIRAW_ARGS := -m 8192 -p 1024KiB $(UBI_ROOT_INI)

# Note: this NAND partition table must align with MFGTool's config.
BOARD_KERNEL_CMDLINE +=  mtdparts=gpmi-nand:64m(bootloader),16m(bootimg),16m(recovery),1m(misc),-(root) ubi.mtd=5
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
TARGET_BOARD_DTS_CONFIG := imx6q-nand:imx6q-sabreauto-gpmi-weim.dtb  imx6dl-nand:imx6dl-sabreauto-gpmi-weim.dtb imx6qp-nand:imx6qp-sabreauto-gpmi-weim.dtb
TARGET_BOOTLOADER_CONFIG := imx6q-nand:mx6qsabreautoandroid_nand_config imx6dl-nand:mx6dlsabreautoandroid_nand_config  imx6qp-nand:mx6qpsabreautoandroid_nand_config
else 
TARGET_BOARD_DTS_CONFIG := imx6q:imx6q-sabreauto.dtb imx6dl:imx6dl-sabreauto.dtb imx6qp:imx6qp-sabreauto.dtb
TARGET_BOOTLOADER_CONFIG := imx6q:mx6qsabreautoandroid_config imx6dl:mx6dlsabreautoandroid_config imx6qp:mx6qpsabreautoandroid_config
endif

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx6/sepolicy \
       device/fsl/sabreauto_6q/sepolicy

PRODUCT_COPY_FILES +=	\
       device/fsl/sabreauto_6q/ueventd.freescale.rc:root/ueventd.freescale.rc

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
       device/fsl/sabreauto_6q/seccomp/mediacodec-seccomp.policy:vendor/etc/seccomp_policy/mediacodec.policy \
       device/fsl/sabreauto_6q/seccomp/mediaextractor-seccomp.policy:vendor/etc/seccomp_policy/mediaextractor.policy

PRODUCT_COPY_FILES += \
       device/fsl/sabreauto_6q/app_whitelist.xml:system/etc/sysconfig/app_whitelist.xml

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers
