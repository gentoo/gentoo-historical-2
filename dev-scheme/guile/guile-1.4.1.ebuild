# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/guile/guile-1.4.1.ebuild,v 1.1 2007/01/10 17:31:47 hkbst Exp $

inherit flag-o-matic

DESCRIPTION="Scheme interpreter"
SRC_URI="mirror://gnu/guile/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/guile/"

SLOT="1.4.1"
LICENSE="GPL-2"
KEYWORDS="x86 ppc alpha"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.1
	>=sys-libs/readline-4.1"

# guile-config breaks with -O3
[ "${ARCH}" == "ppc" ] && replace-flags -O3 -O2

src_compile() {
	econf \
		--with-threads \
		--with-modules || die "Configuration failed"
	make || die "Compilation failed"
}

src_install() {
	einstall || die "Installation failed"
	dodoc ANON-CVS AUTHORS ChangeLog HACKING NEWS README SNAPSHOTS THANKS
}
