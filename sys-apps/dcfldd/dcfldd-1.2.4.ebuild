# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dcfldd/dcfldd-1.2.4.ebuild,v 1.1.1.1 2005/11/30 09:56:43 chriswhite Exp $

DESCRIPTION="enhanced dd with features for forensics and security"
HOMEPAGE="http://dcfldd.sourceforge.net/"
SRC_URI="mirror://sourceforge/dcfldd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-amd64 ~ppc x86"
# -amd64 in this version because of bug 108653 - bad md5 impliementation on
# x86_64
IUSE=""

DEPEND=""

src_install() {
	make install DESTDIR="${D}" || die "make install failed"
	dodoc AUTHORS ChangeLog README
}
