# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/fdutils/fdutils-5.5.ebuild,v 1.5 2006/04/02 23:06:42 robbat2 Exp $

inherit eutils flag-o-matic

DESCRIPTION="utilities for configuring and debugging the Linux floppy driver"
HOMEPAGE="http://fdutils.linux.lu/"
SRC_URI="http://fdutils.linux.lu/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE="doc"

DEPEND=">=sys-fs/mtools-3
	doc? ( virtual/tetex )"

src_unpack() {
	unpack ${A}
	cd ${S}
	# the man 4 fd manpage is better in the man-pages package, so stop it
	# from installing
	epatch ${FILESDIR}/${PN}-no-fd.4-manpage.diff
	epatch ${FILESDIR}/${P}-destdirfix.patch
}

src_compile() {
	append-ldflags $(bindnow-flags)
	econf --enable-fdmount-floppy-only || die

	if use doc;
	then
		make || die
	else
		make compile || die
	fi
}

src_install() {
	dodoc Changelog
	use doc && dodir /usr/share/info/
	emake -j1 DESTDIR=${D} install || die
}
