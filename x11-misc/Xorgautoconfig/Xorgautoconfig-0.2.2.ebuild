# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/Xorgautoconfig/Xorgautoconfig-0.2.2.ebuild,v 1.1 2006/01/06 21:28:16 josejx Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Xorgautconfig generates xorg.conf files for PPC based computers."
HOMEPAGE="http://ppc.gentoo.org"
SRC_URI="http://dev.gentoo.org/~josejx/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~ppc64"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/pciutils"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "/^CC=/s:gcc:$(tc-getCC):" Makefile || die "Can't replace CC"
}

src_compile() {
	emake || die "emake failed!"
}

src_install() {
	dodir /usr
	into /usr
	dosbin Xorgautoconfig

	exeinto /etc/init.d
	newexe Xorgautoconfig.init Xorgautoconfig

	dodoc ChangeLog
}
