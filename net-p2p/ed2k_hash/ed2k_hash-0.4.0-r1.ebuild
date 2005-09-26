# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/ed2k_hash/ed2k_hash-0.4.0-r1.ebuild,v 1.1 2005/09/26 14:32:29 mkay Exp $

inherit flag-o-matic eutils

DESCRIPTION="Tool for generating eDonkey2000 links"
HOMEPAGE="http://ed2k-tools.sourceforge.net/${PN}.shtml"
RESTRICT="nomirror"
SRC_URI="mirror://sourceforge/ed2k-tools/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="fltk"
DEPEND="fltk? ( x11-libs/fltk )"

src_unpack() {
	unpack ${P}.tar.gz
	epatch ${FILESDIR}/ed2k_64bit.patch
}

src_compile() {
	if use fltk; then
		append-ldflags "$(fltk-config --ldflags)"
		export CPPFLAGS="$(fltk-config --cxxflags)"
	else
		export ac_cv_lib_fltk_main='no'
	fi

	econf --disable-dependency-tracking
	emake
}

src_install() {
	make install DESTDIR=${D} mydocdir=${D}/usr/share/doc/${PF}/html || die

	dodoc AUTHORS COPYING INSTALL README TODO
}
