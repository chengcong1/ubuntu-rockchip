# shellcheck shell=bash

export BOARD_NAME="Orange Pi 5 Plus"
export BOARD_MAKER="Xulong"
export UBOOT_PACKAGE="u-boot-orangepi-rk3588"
export UBOOT_RULES_TARGET="orangepi_5_plus"

function config_image_hook__orangepi-5-plus() {
    local rootfs="$1"
    local overlay="$2"

    # Install panfork
    chroot "${rootfs}" add-apt-repository -y ppa:oibaf/graphics-drivers
    chroot "${rootfs}" apt-get update
    # chroot "${rootfs}" apt-get -y install mali-g610-firmware
    chroot "${rootfs}" apt-get -y dist-upgrade

    # Fix WiFi not working when bluetooth enabled for the official RTL8852BE WiFi + BT card
    mkdir -p "${rootfs}"/usr/lib/scripts
    cp "${overlay}/usr/lib/systemd/system/rtl8852be-reload.service" "${rootfs}/usr/lib/systemd/system/rtl8852be-reload.service"
    cp "${overlay}/usr/lib/scripts/rtl8852be-reload.sh" "${rootfs}/usr/lib/scripts/rtl8852be-reload.sh"
    chroot "${rootfs}" systemctl enable rtl8852be-reload

    # Install wiring orangepi package 
    chroot "${rootfs}" apt-get -y install wiringpi-opi libwiringpi2-opi libwiringpi-opi-dev
    echo "BOARD=orangepi5plus" > "${rootfs}/etc/orangepi-release"

    return 0
}
