# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdc1394/libdc1394-1.2.2.ebuild,v 1.6 2010/05/22 15:07:36 armin76 Exp $

inherit eutils flag-o-matic

DESCRIPTION="Library to interface with IEEE 1394 cameras following the IIDC specification"
HOMEPAGE="http://sourceforge.net/projects/libdc1394/"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~ppc ppc64 sparc x86"
IUSE="X"

RDEPEND="sys-libs/libraw1394
		X? ( x11-libs/libSM x11-libs/libXv )"
DEPEND="${RDEPEND}
	sys-devel/libtool"

src_unpack() {
	unpack ${A}; cd "${S}"
	if ! use X; then
		epatch "${FILESDIR}"/${PN}-1.2.1-nox11.patch
	fi
	epatch "${FILESDIR}"/${PN}-disable-raw-capture.patch
}

src_compile() {
	if has_version '>=sys-libs/glibc-2.4' ; then
		append-flags "-DCLK_TCK=CLOCKS_PER_SEC"
	fi

	econf || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc NEWS README AUTHORS
}
