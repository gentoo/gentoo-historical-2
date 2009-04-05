# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-tslib/xf86-input-tslib-0.0.5-r1.ebuild,v 1.6 2009/04/05 22:08:42 maekke Exp $

# Based on xf86-input-synaptics ebuild

inherit toolchain-funcs eutils linux-info x-modular

PATCHLEVEL=6
PATCHFILE="${PN}_${PV}-${PATCHLEVEL}.diff"

DESCRIPTION="xorg input driver for use of tslib based touchscreen devices"
HOMEPAGE="http://www.pengutronix.de/software/${PN}/index_en.html"
SRC_URI="http://www.pengutronix.de/software/${PN}/download/${P}.tar.bz2
	ftp://cdn.debian.net/debian/pool/main/x/${PN}/${PATCHFILE}.gz"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~sh ~sparc x86"
LICENSE="GPL-2"
IUSE=""
RDEPEND="x11-base/xorg-server x11-libs/tslib"
DEPEND="x11-proto/inputproto"

evdev-input_check() {
	# Check kernel config for required event interface support (either
	# built-in or as a module. Bug #134309.

	ebegin "Checking kernel config for event device support"
	linux_chkconfig_present INPUT_EVDEV
	eend $?

	if [[ $? -ne 0 ]] ; then
		ewarn "tslib x11 input driver requires event interface support."
		ewarn "Please enable the event interface in your kernel config."
		ewarn "The option can be found at:"
		ewarn
		ewarn "  Device Drivers"
		ewarn "    Input device support"
		ewarn "      -*- Generic input layer"
		ewarn "        <*> Event interface"
		ewarn
		ewarn "Then rebuild the kernel or install the module."
		epause 5
	fi
}

pkg_setup() {
	linux-info_pkg_setup
	evdev-input_check
}

src_unpack() {
	x-modular_unpack_source
	cd "${WORKDIR}"
	epatch "${WORKDIR}/${PATCHFILE}"
	EPATCH_OPTS="-p0" EPATCH_SOURCE="${S}/debian/patches" EPATCH_SUFFIX="diff" EPATCH_FORCE="yes" epatch
}

src_install() {
	DOCS="COPYING ChangeLog"
	x-modular_src_install
	insinto /usr/share/hal/fdi/policy/20thirdparty/
	doins "${S}/debian/10-x11-input-tslib.fdi"
}
