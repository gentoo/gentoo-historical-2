# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/rinetd/rinetd-0.62.ebuild,v 1.3 2004/07/15 03:23:48 agriffis Exp $

DESCRIPTION="redirects TCP connections from one IP address and port to another"
HOMEPAGE="http://www.boutell.com/rinetd/"
SRC_URI="http://www.boutell.com/rinetd/http/rinetd.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="sys-devel/gcc"

S=${WORKDIR}/${PN}

src_compile() {
	emake CFLAGS="${CFLAGS} -DLINUX" || die
}

src_install() {
	dosbin rinetd
	doman rinetd.8
	dodoc CHANGES README
	dohtml index.html
}
