# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/jfbterm/jfbterm-0.4.5.ebuild,v 1.2 2004/04/18 18:50:19 usata Exp $

inherit flag-o-matic

DESCRIPTION="The J Framebuffer Terminal/Multilingual Enhancement with UTF-8 support"
HOMEPAGE="http://jfbterm.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/8544/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc"

DEPEND="virtual/glibc
	>=sys-apps/sed-4
	>=sys-devel/autoconf-2.58
	sys-devel/automake
	sys-libs/ncurses"
RDEPEND="virtual/glibc"

src_compile() {
	replace-flags -march=pentium3 -mcpu=pentium3

	export WANT_AUTOCONF=2.5
	econf || die "econf failed"
	# jfbterm peculiarly needs to be compiled twice.
	emake -j1 || die "make failed"
	emake -j1 || die "make failed"
	sed -i -e 's/a18/8x16/' jfbterm.conf.sample
}

src_install() {
	dodir /etc /usr/share/fonts/jfbterm
	einstall || die

	dodir /usr/share/terminfo
	tic terminfo.jfbterm -o${D}/usr/share/terminfo || die

	mv ${D}/etc/jfbterm.conf{.sample,}

	doman jfbterm.1 jfbterm.conf.5

	dodoc AUTHORS ChangeLog INSTALL* NEWS README*
	dodoc jfbterm.conf.sample*
}
