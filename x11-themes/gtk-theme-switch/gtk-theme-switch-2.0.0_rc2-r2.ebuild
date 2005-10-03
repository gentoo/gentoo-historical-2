# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-theme-switch/gtk-theme-switch-2.0.0_rc2-r2.ebuild,v 1.5 2005/10/03 19:43:38 corsair Exp $

inherit eutils

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Application for easy change of GTK-Themes"
HOMEPAGE="http://www.muhri.net/nav.php3?node=gts"
SRC_URI="http://www.muhri.net/${MY_P}.tar.gz
	mirror://gentoo/${MY_P}b.patch.gz"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

DEPEND="=x11-libs/gtk+-2*"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/${MY_P}b.patch

	# fix compilation with gtk+-2.4 (#45105)
	epatch ${FILESDIR}/${P}-gtk+-2.4_fix.patch

}

src_compile() {
	make || die
}

src_install() {

	dobin switch2
	newman switch.1 gtk-theme-switch2.1
	dosym gtk-theme-switch2.1 /usr/share/man/man1/switch2.1
}
