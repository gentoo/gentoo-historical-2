# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/yafc/yafc-1.1.ebuild,v 1.2 2004/06/19 17:03:39 weeve Exp $

inherit flag-o-matic

DESCRIPTION="Console ftp client with a lot of nifty features"
HOMEPAGE="http://yafc.sourceforge.net/"
SRC_URI="mirror://sourceforge/yafc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE="readline"

DEPEND="readline? ( >=sys-libs/readline-4.1-r4 )"
RDEPEND=">=net-misc/openssh-3.0"

src_compile() {
	econf `use_with readline` || die "./configure failed"
	emake || die "emake failed"
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc BUGS COPYRIGHT INSTALL NEWS README THANKS TODO *.sample
}
