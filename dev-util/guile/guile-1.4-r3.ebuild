# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/guile/guile-1.4-r3.ebuild,v 1.18 2004/10/17 22:19:17 liquidx Exp $

inherit gnuconfig eutils

DESCRIPTION="Scheme interpreter"
SRC_URI="mirror://gnu/guile/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/guile/"

SLOT="1.4"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc amd64"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.1
	>=sys-libs/readline-4.1"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-inet_aton.patch
}

src_compile() {
	gnuconfig_update

	econf \
		--with-threads \
		--with-modules || die
	make || die
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog GUILE-VERSION HACKING NEWS README SNAPSHOTS THANKS
}
