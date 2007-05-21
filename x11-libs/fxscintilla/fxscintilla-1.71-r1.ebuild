# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/fxscintilla/fxscintilla-1.71-r1.ebuild,v 1.4 2007/05/21 03:24:38 jer Exp $

inherit eutils multilib

DESCRIPTION="A free source code editing component for the FOX-Toolkit"
HOMEPAGE="http://www.nongnu.org/fxscintilla/"
SRC_URI="http://savannah.nongnu.org/download/fxscintilla/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha ~amd64 hppa ppc ~ppc64 ~sparc ~x86"
IUSE="doc"

DEPEND="=x11-libs/fox-1.4*
	=x11-libs/fox-1.6*"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/1.71-shared-libs.patch || die
	epatch ${FILESDIR}/1.71-fox-SLOT.patch || die

	einfo "Running autoreconf..."
	touch NEWS AUTHORS
	autoreconf --install --force || die "autoreconf error"
}

src_compile () {
	# Borrowed from wxGTK ebuild

	einfo "Building ${PN} for FOX-1.4..."
	mkdir ${S}/build_1_4
	cd ${S}/build_1_4
	../configure \
		--prefix=/usr \
		--includedir=/usr/include \
		--libdir=/usr/$(get_libdir) \
		${EXTRA_ECONF} \
		--enable-nolexer \
		--with-fox-1-4 \
		--with-foxinclude=/usr/include \
		--with-foxlib=/usr/lib \
		|| die "configure error"
	emake || die "make error"

	einfo "Building ${PN} for FOX-1.6..."
	mkdir ${S}/build_1_6
	cd ${S}/build_1_6
	../configure \
		--prefix=/usr \
		--includedir=/usr/include \
		--libdir=/usr/$(get_libdir) \
		${EXTRA_ECONF} \
		--enable-nolexer \
		--with-fox-1-6 \
		--with-foxinclude=/usr/include \
		|| die "configure error"
	emake || die "make error"
}

src_install () {
	cd ${S}/build_1_4
	emake DESTDIR="${D}" install || die "make install error"

	cd ${S}/build_1_6
	emake DESTDIR="${D}" install || die "make install error"

	cd ${S}
	dodoc README
	if use doc ; then
		dodoc scintilla/doc/Lexer.txt
		dohtml scintilla/doc/*
	fi
}

pkg_postinst() {
	elog "New as of 1.71-r1:"
	elog "FXScintilla is now built separately against FOX-1.4 and -1.6."
	elog "Support for FOX-1.0 has been dropped upstream."
	elog "Support for FOX-1.2 has been dropped by gentoo."
	elog "The Librarys are named for the FOX-release they correspond to, for"
	elog "example: For FOX-1.4, the library is called libfxscintilla-1.4."
	elog "Anything linked against previous releases of FOX and fxscintilla"
	elog "may need to be rebuilt."
	elog
	elog "The nolexer libraries are now included in this release as well."
}
