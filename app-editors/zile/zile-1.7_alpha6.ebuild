# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/zile/zile-1.7_alpha6.ebuild,v 1.11 2005/01/01 13:37:53 eradicator Exp $

DESCRIPTION="tiny emacs clone"
HOMEPAGE="http://zile.sourceforge.net/"
SRC_URI="mirror://sourceforge/zile/${P/_alpha/-a}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5.2"

S="${WORKDIR}/${P/_alpha/-a}"

src_compile() {
	econf || die
	make || die
}

src_install() {
	dodir /usr/share/man
	keepdir /var/lib/{exrecover,expreserve}
	make INSTALL=/usr/bin/install \
		DESTDIR=${D} \
		infodir=/usr/share/info\
		MANDIR=/usr/share/man \
		TERMLIB=termlib \
		PRESERVEDIR=${D}/var/lib/expreserve \
		RECOVER="-DEXRECOVER=\\\"/var/lib/exrecover\\\" \
			-DEXPRESERVE=\\\"/var/lib/expreserve\\\"" \
		install || die

	dodoc COPYRIGHT CREDITS HISTORY KNOWNBUGS NEWS README* TODO LICENSE
}
