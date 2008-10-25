# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/zhcon/zhcon-0.2.6-r1.ebuild,v 1.1 2008/10/25 11:29:36 flameeyes Exp $

WANT_AUTOMAKE="1.9"

inherit eutils autotools

MY_P=${P/6/5}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="A Fast CJK (Chinese/Japanese/Korean) Console Environment"
HOMEPAGE="http://zhcon.sourceforge.net/"
SRC_URI="mirror://sourceforge/zhcon/${MY_P}.tar.gz
		mirror://sourceforge/zhcon/zhcon-0.2.5-to-0.2.6.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${DISTDIR}"/zhcon-0.2.5-to-0.2.6.diff.gz
	epatch "${FILESDIR}"/zhcon-0.2.5.make-fix.patch
	epatch "${FILESDIR}"/${P}.sysconfdir.patch
	epatch "${FILESDIR}"/${P}.configure.in.patch
	epatch "${FILESDIR}"/${P}+gcc-4.3.patch
	epatch "${FILESDIR}"/${P}+linux-headers-2.6.26.patch
	epatch "${FILESDIR}"/${P}-curses.patch
	epatch "${FILESDIR}"/${P}-amd64.patch
	eautoreconf
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README NEWS TODO THANKS
	dodoc ABOUT-NLS README.BSD README.gpm README.utf8
}
