# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/zhcon/zhcon-0.2.3.ebuild,v 1.5 2004/06/28 02:08:21 vapier Exp $

inherit eutils

DESCRIPTION="A Fast CJK (Chinese/Japanese/Korean) Console Environment"
HOMEPAGE="http://zhcon.sourceforge.net/"
SRC_URI="mirror://sourceforge/zhcon/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/libc
	sys-devel/autoconf"
RDEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-gentoo.diff
	epatch ${FILESDIR}/${P}-assert-gentoo.diff
}

src_compile() {
	autoconf || die "autoconf failed"
	econf || die
	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die
}
