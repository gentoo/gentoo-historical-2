# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/xc/xc-4.3.2.ebuild,v 1.4 2003/02/13 13:56:21 vapier Exp $

DESCRIPTION="unix dialout program"
HOMEPAGE="http://www.ibiblio.org/pub/Linux/apps/serialcomm/dialout/"
SRC_URI="http://www.ibiblio.org/pub/Linux/apps/serialcomm/dialout/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="x86"
DEPEND="sys-libs/libtermcap-compat"
RDEPEND=""
S="${WORKDIR}/${P}"

src_unpack() {
	unpack ${A}

	cd ${S}
	patch -p0 <${FILESDIR}/${PF}-gentoo.diff
}

src_compile() {
	make all prefix=/usr mandir=/usr/share/man || die

}

src_install () {
	dodir /usr/bin /usr/share/man/man1 /usr/lib/xc

	make DESTDIR=${D} install || die
	
	insinto /usr/lib/xc
	doins phonelist xc.init dotfiles/.[a-z]*
}
