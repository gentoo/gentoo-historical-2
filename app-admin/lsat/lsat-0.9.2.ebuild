# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/lsat/lsat-0.9.2.ebuild,v 1.2 2005/06/14 14:33:29 matsuu Exp $

inherit eutils

DESCRIPTION="The Linux Security Auditing Tool"
HOMEPAGE="http://usat.sourceforge.net/"
SRC_URI="http://usat.sourceforge.net/code/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc amd64"
IUSE=""

RDEPEND="virtual/libc
	dev-libs/popt"
DEPEND="${RDEPEND}
	dev-lang/perl"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	econf || die
	emake CFLAGS="${CFLAGS}" SLIBS="-lpopt" all manpage || die
}

src_install() {
	dobin lsat || die
	doman lsat.1
	dodoc INSTALL README* *.txt
	dohtml modules.html changelog/changelog.html
}
