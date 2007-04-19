# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/fxscintilla/fxscintilla-1.62-r2.ebuild,v 1.6 2007/04/19 13:02:00 fmccor Exp $

inherit eutils

DESCRIPTION="A free source code editing component for the FOX-Toolkit"
HOMEPAGE="http://www.nongnu.org/fxscintilla/"
SRC_URI="http://savannah.nongnu.org/download/fxscintilla/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="doc"

DEPEND="=x11-libs/fox-1.2*"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/1.62-shared-libs.patch || die
	epatch ${FILESDIR}/1.62-fox-SLOT.patch || die

	einfo "Running autoreconf..."
	touch NEWS AUTHORS
	autoreconf --install --force || die "autoreconf error"
}

src_compile () {
	# Borrowed from wxGTK ebuild

	einfo "Building ${PN} for FOX-1.2..."
	mkdir ${S}/build_1_2
	cd ${S}/build_1_2
	../configure \
		--prefix=/usr \
		--includedir=/usr/include \
		--libdir="/usr/$(get_libdir)" \
		${EXTRA_ECONF} \
		--enable-nolexer \
		--with-foxinclude=/usr/include \
		--with-foxlib=/usr/lib \
		|| die "configure error"
	emake || die "make error"
}

src_install () {
	cd ${S}/build_1_2
	make DESTDIR="${D}" install || die "make install error"

	cd ${S}
	dodoc README
	if use doc ; then
		dodoc scintilla/doc/Lexer.txt
		dohtml scintilla/doc/*
	fi
}

pkg_postinst() {
	elog "New as of 1.62-r2:"
	elog "FXScintilla is now built only against FOX-1.2."
	elog "For FOX-1.2, the library is called libfxscintilla-1.2."
	elog "Anything linked against previous releases of FOX-1.2 and fxscintilla"
	elog "may need to be rebuilt."
	elog
	elog "The nolexer libraries are now included in this release as well."
}
