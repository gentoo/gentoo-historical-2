# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/aspell/aspell-0.50.5-r1.ebuild,v 1.4 2004/06/09 21:44:23 gmsoft Exp $

inherit libtool eutils

DESCRIPTION="A spell checker replacement for ispell"
HOMEPAGE="http://aspell.net/"
SRC_URI="http://aspell.net/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~sparc ~mips ~alpha ~arm hppa ~amd64 ~ia64 s390"
IUSE="gpm"

DEPEND=">=sys-libs/ncurses-5.2
	gpm? ( sys-libs/gpm )"

pkg_setup() {
	if [ ${ARCH} = "ppc" ] ; then
		CXXFLAGS="-O2 -fsigned-char"
		CFLAGS=${CXXFLAGS}
	fi
	use gpm && LDFLAGS="-lgpm"
}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-buffer-fix.patch
}

src_compile() {
	elibtoolize --reverse-deps

	econf \
		--disable-static \
		--sysconfdir=/etc/aspell \
		--enable-docdir=/usr/share/doc/${PF} || die

	emake || die
}

src_install() {
	dodoc README* TODO

	make DESTDIR=${D} install || die
	mv ${D}/usr/share/doc/${PF}/man-html ${D}/usr/share/doc/${PF}/html
	mv ${D}/usr/share/doc/${PF}/man-text ${D}/usr/share/doc/${PF}/text

	# install ispell/aspell compatibility scripts
	exeinto /usr/bin
	newexe scripts/ispell ispell-aspell
	newexe scripts/spell spell-aspell

	cd examples
	make clean || die
	docinto examples
	dodoc ${S}/examples/*

}

pkg_postinst() {
	einfo "You will need to install a dictionary now.  Please choose an"
	einfo "aspell-<LANG> dictionary from the app-dicts category"
	einfo "After installing an aspell dictionary for your language(s),"
	einfo "You may use the aspell-import utility to import your personal"
	einfo "dictionaries from ispell, pspell and the older aspell"
}
