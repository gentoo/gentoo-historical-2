# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-theme-switch/gtk-theme-switch-2.0.0_rc2-r2.ebuild,v 1.14 2010/06/16 14:37:02 ssuominen Exp $

inherit eutils toolchain-funcs

MY_P=${P/_/}

DESCRIPTION="Application for easy change of GTK-Themes"
HOMEPAGE="http://www.muhri.net/nav.php3?node=gts"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz
	mirror://gentoo/${MY_P}b.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RDEPEND="=x11-libs/gtk+-2*"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${MY_P}b.patch \
		"${FILESDIR}"/${P}-gtk+-2.4_fix.patch
}

src_compile() {
	emake GCC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -Wall $(pkg-config --cflags gtk+-2.0)" \
		|| die "emake failed."
}

src_install() {
	dobin switch2
	newman switch.1 gtk-theme-switch2.1
	dosym gtk-theme-switch2.1 /usr/share/man/man1/switch2.1
}
