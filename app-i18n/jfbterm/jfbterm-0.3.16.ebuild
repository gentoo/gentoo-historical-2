# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/jfbterm/jfbterm-0.3.16.ebuild,v 1.7 2004/04/25 22:10:45 agriffis Exp $

inherit flag-o-matic
replace-flags "-march=pentium3" "-mcpu=pentium3"

DESCRIPTION="A Japanized framebuffer terminal with Multilingual Enhancement"
HOMEPAGE="http://jfbterm.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/5788/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ppc sparc"

DEPEND="virtual/glibc
	>=sys-apps/sed-4
	>=sys-devel/autoconf-2.53a
	sys-devel/automake
	sys-libs/ncurses"
RDEPEND="virtual/glibc"

src_compile() {

	export WANT_AUTOCONF_2_5=1
	econf || die "econf failed"
	# jfbterm peculiarly needs to be compiled twice.
	make || die "make failed"
	make || die "make failed"
	sed -i -e 's/a18/8x16/' jfbterm.conf.sample
}

src_install() {

	dodir /etc
	einstall || die

	dodir /usr/share/terminfo
	tic terminfo.jfbterm -o${D}/usr/share/terminfo || die

	mv ${D}/etc/jfbterm.conf{.sample,}

	doman jfbterm.1 jfbterm.conf.5

	dodoc AUTHORS ChangeLog INSTALL* NEWS README*
	dodoc jfbterm.conf.sample*
}
