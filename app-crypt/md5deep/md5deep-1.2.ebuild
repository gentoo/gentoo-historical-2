# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/md5deep/md5deep-1.2.ebuild,v 1.2 2004/06/24 21:34:32 agriffis Exp $

DESCRIPTION="Expanded md5sum program that has recursive and comparison options"
HOMEPAGE="http://md5deep.sourceforge.net"
SRC_URI="mirror://sourceforge/md5deep/${P}.tar.gz"
LICENSE="freedist"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"
IUSE=""
DEPEND=""
S=${WORKDIR}/${P}

src_unpack () {
	unpack ${A} ; cd ${S}
}

src_compile () {
	make CFLAGS="${CFLAGS}" linux || die
}

src_install() {
	dobin md5deep sha1deep
	dodoc README CHANGES
	doman md5deep.1 sha1deep.1
}
