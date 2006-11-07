# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/setarch/setarch-2.0.ebuild,v 1.2 2006/11/07 21:41:02 gustavoz Exp $

inherit eutils

DESCRIPTION="change reported architecture in new program environment and set personality flags"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~ia64 ~mips ~ppc ~ppc64 ~s390 sparc ~x86"
IUSE=""

RDEPEND="!sys-apps/linux32
	!sys-devel/mips32
	!sys-devel/sparc32
	!sys-devel/ppc32"

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp "${FILESDIR}"/Makefile . || die
	epatch "${FILESDIR}"/${PN}-1.8-linux-headers.patch
	epatch "${FILESDIR}"/${PN}-1.9-links.patch
}

src_install() {
	make install DESTDIR="${D}" || die
}
