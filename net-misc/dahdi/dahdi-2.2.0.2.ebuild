# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dahdi/dahdi-2.2.0.2.ebuild,v 1.2 2010/05/18 14:28:06 chainsaw Exp $

inherit linux-mod eutils flag-o-matic

MY_P="${P/dahdi/dahdi-linux}"
MY_S="${WORKDIR}/${MY_P}"
RESTRICT="test"

DESCRIPTION="Kernel modules for Digium compatible hardware (formerly known as Zaptel)."
HOMEPAGE="http://www.asterisk.org"
SRC_URI="http://downloads.digium.com/pub/telephony/dahdi-linux/releases/${MY_P}.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fwload-vpmadt032-1.17.0.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-oct6114-064-1.05.01.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-oct6114-128-1.05.01.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-tc400m-MR6.12.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-vpmadt032-1.07.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}

	# Fix udev rules to work with both asterisk and callweaver
	sed -i 's/GROUP="asterisk"/GROUP="dialout"/' "${MY_S}"/build_tools/genudevrules

	# Copy the firmware tarballs over, the makefile will try and download them otherwise
	for file in ${A} ; do
		cp "${DISTDIR}"/${file} "${MY_P}"/drivers/dahdi/firmware/
	done
	# But without the .bin's it'll still fall over and die, so copy those too.
	cp *.bin "${MY_P}"/drivers/dahdi/firmware/

	epatch "${FILESDIR}"/${P}-no-depmod.patch

	# https://issues.asterisk.org/view.php?id=15747
	epatch "${FILESDIR}"/${P}-net-device-ops.patch

	# If you want TASK_INTERRUPTIBLE you need <linux/sched.h>, hmmkay?
	epatch "${FILESDIR}"/${P}-includes.patch

	# https://issues.asterisk.org/view.php?id=16114
	epatch "${FILESDIR}"/${P}-driver_data-2.6.32.patch

	# GCC 4.4 compatibility, the quick 'n dirty way
	# error: dereferencing pointer to incomplete type
	epatch "${FILESDIR}"/${P}-gcc44-hack.patch
}

src_compile() {
	cd "${MY_P}"
	unset ARCH
	emake KSRC="${KERNEL_DIR}" DESTDIR="${D}" all || die "Compilation failed"
}

src_install() {
	cd "${MY_P}"

	# setup directory structure so udev rules get installed
	mkdir -p "${D}"/etc/udev/rules.d

	einfo "Installing kernel module"
	emake KSRC="${KERNEL_DIR}" DESTDIR="${D}" install || die "Installation failed"
	rm -rf "$D"/lib/modules/*/modules.*
}
