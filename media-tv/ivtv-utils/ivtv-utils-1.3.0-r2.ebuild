# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/ivtv-utils/ivtv-utils-1.3.0-r2.ebuild,v 1.1 2010/01/19 05:18:14 cardoe Exp $

EAPI=2

inherit eutils linux-mod linux-info

DESCRIPTION="IVTV utilities for Hauppauge PVR PCI cards"
HOMEPAGE="http://www.ivtvdriver.org"
SRC_URI="http://dl.ivtvdriver.org/ivtv/archive/1.3.x/${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="perl"
RDEPEND=">=sys-fs/udev-103"
DEPEND="app-arch/unzip
	<sys-kernel/linux-headers-2.6.29
	>=sys-kernel/linux-headers-2.6.26
	!media-tv/ivtv"
PDEPEND=">=media-tv/ivtv-firmware-20070217
	perl? (
		dev-perl/Video-Frequencies
		dev-perl/Video-ivtv
		dev-perl/Config-IniFiles
		virtual/perl-Getopt-Long
		dev-perl/perl-tk )"

pkg_setup() {
	linux-info_pkg_setup

	MODULE_NAMES="saa717x(extra:${S}/i2c-drivers)"
	BUILD_TARGETS="all"
	CONFIG_CHECK="~EXPERIMENTAL ~KMOD ~HAS_IOMEM ~FW_LOADER ~I2C ~I2C_ALGOBIT
		~VIDEO_DEV ~VIDEO_CAPTURE_DRIVERS ~VIDEO_V4L1 ~VIDEO_V4L2 ~VIDEO_IVTV"

	if ! ( kernel_is ge 2 6 26 && kernel_is le 2 6 28 ); then
		eerror "This package is only for the fully in-kernel"
		eerror "IVTV driver shipping with kernel 2.6.26 - 2.6.28"
		eerror ""
		eerror "You will need to either:"
		eerror "a) emerge a 2.6.26.x - 2.6.28.x kernel"
		eerror "b) emerge media-tv/ivtv or media-tv/ivtv-utils for"
		eerror "your kernel version"
		eerror ""
		eerror "See http://ivtvdriver.org/ for more information"
		die "This only works on 2.6.26 - 2.6.28 kernels"
	fi

	ewarn ""
	ewarn "Make sure that your I2C and V4L kernel drivers are loaded as"
	ewarn "modules, and not compiled into the kernel, or IVTV will not"
	ewarn "work."
	ewarn ""

	linux-mod_pkg_setup

	BUILD_PARAMS="KDIR=${KV_DIR}"
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-2.6.27.patch
}

src_compile() {
	emake  || die "failed to build"

	linux-mod_src_compile
}

src_install() {
	make DESTDIR="${D}" PREFIX="/usr" install || die "failed to install"
	use perl && dobin utils/perl/*.pl

	cd "${S}"
	dodoc README doc/* ChangeLog
	use perl && dodoc utils/perl/README.ptune

	linux-mod_src_install
}

pkg_postinst() {
	linux-mod_pkg_postinst

	elog ""
	elog "This version of the IVTV utils supports hardware listed at:"
	elog "http://www.ivtvdriver.org/index.php/Supported_hardware"
	ewarn ""
	ewarn "IMPORTANT: In case of problems first read the following:"
	ewarn "http://www.ivtvdriver.org/index.php/Troubleshooting"
	ewarn "/usr/share/doc/${PF}/README.*"
	ewarn ""
	ewarn " - Using MythTV, a PVR-350 and the ivtvfb module"
	ewarn " - Using the ivtv X driver and the ivtvfb module"
	ewarn " - You want to manually build ivtv against v4l-dvb"
	ewarn ""
	ewarn "Also, the ivtv package comes with lots of documentation regarding "
	ewarn "setup, proper use and debugging utilities."
	ewarn "They are also located in /usr/share/doc/${PF}/"
	ewarn ""
	elog "For more information, see the IVTV driver homepage at:"
	elog "http://www.ivtvdriver.org/"
}
