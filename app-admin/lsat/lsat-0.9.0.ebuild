# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/lsat/lsat-0.9.0.ebuild,v 1.6 2004/06/25 18:03:57 vapier Exp $

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
