# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/msieve/msieve-1.50.ebuild,v 1.1 2012/11/16 03:32:43 patrick Exp $

EAPI=4
DESCRIPTION="A C library implementing a suite of algorithms to factor large integers"
HOMEPAGE="http://sourceforge.net/projects/msieve/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/Msieve%20v${PV}/${PN}${PV/./}src.tar.gz"

inherit eutils

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="zlib"
# ecm needs gmp tweaks

#DEPEND="ecm? ( dev-libs/gmp )
DEPEND="
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

src_compile() {
	if use ecm; then
		export "ECM=1"
	fi
	if use zlib; then
		export "ZLIB=1"
	fi
	if use amd64; then
		emake x86_64 || die "Failed to build"
	fi
	if use x86; then
		emake x86 || die "Failed to build"
	fi
}

src_install() {
	mkdir -p "${D}/usr/include/"
	mkdir -p "${D}/usr/lib/"
	mkdir -p "${D}/usr/share/doc/${P}/"
	cp include/* "${D}/usr/include/" || die "Failed to install"
	cp libmsieve.a "${D}/usr/lib/" || die "Failed to install"
	dobin msieve || die "Failed to install"
	cp Readme* "${D}/usr/share/doc/${P}/" || die "Failed to install"
}
