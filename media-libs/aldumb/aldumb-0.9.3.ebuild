# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/aldumb/aldumb-0.9.3.ebuild,v 1.5 2009/10/24 11:33:27 nixnut Exp $

inherit eutils

IUSE="debug"

DESCRIPTION="Allegro support for DUMB (an IT, XM, S3M, and MOD player library)"
HOMEPAGE="http://dumb.sourceforge.net/"
SRC_URI="mirror://sourceforge/dumb/dumb-${PV}.tar.gz"

LICENSE="DUMB-0.9.2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc x86"

DEPEND=">=media-libs/dumb-0.9.3
	media-libs/allegro"

S="${WORKDIR}/${P/aldumb/dumb}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	cat << EOF > make/config.txt
include make/unix.inc
ALL_TARGETS := allegro allegro-examples allegro-headers
PREFIX := /usr
EOF
	epatch "${FILESDIR}/${PN}-0.9.2-PIC.patch"
	epatch "${FILESDIR}/${P}_CVE-2006-3668.patch"
	sed -i '/= -s/d' Makefile || die "sed failed"
	cp Makefile Makefile.rdy
}

src_compile() {
	emake OFLAGS="${CFLAGS}" all || die "emake failed"
}

src_install() {
	dobin examples/dumbplay
	dolib.so lib/unix/libaldmb.so

	use debug && lib/unix/libaldmd.so

	insinto /usr/include
	doins include/aldumb.h
}
