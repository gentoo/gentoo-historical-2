# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libptp2/libptp2-1.1.0.ebuild,v 1.6 2006/07/25 04:47:20 dragonheart Exp $

inherit eutils

DESCRIPTION="Library and client for communicating with PTP enabled devices (e.g. digital photo cameras)."
HOMEPAGE="http://sourceforge.net/projects/libptp/"
SRC_URI="mirror://sourceforge/libptp/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 x86"
IUSE=""
RDEPEND=">=dev-libs/libusb-0.1.8"
DEPEND="${RDEPEND}
	sys-apps/gawk
	sys-apps/grep"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-1.1.0-libusbversion.patch
	epatch "${FILESDIR}"/${PN}-1.1.0-parallel.patch
	epatch "${FILESDIR}"/${PN}-1.1.0-gcc41.patch
}

src_test() {
	if hasq userpriv "${FEATURES}" || hasq sandbox "${FEATURES}" || hasq usersandbox "${FEATURES}";
	then
		einfo "Sorry cannot test with userpriv, usersandbox or sandbox features"
	else
		env LD_LIBRARY_PATH=./src/.libs/ ./src/ptpcam -l || die "failed test"
	fi
}

src_install() {
	make DESTDIR="${D}" install || die
}
