# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ttyrec/ttyrec-1.0.6-r1.ebuild,v 1.3 2009/09/23 16:08:00 patrick Exp $

DESCRIPTION="tty recorder"
HOMEPAGE="http://namazu.org/~satoru/ttyrec/"
SRC_URI="http://namazu.org/~satoru/ttyrec/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=""

src_compile() {
	local mycflags
	mycflags="${CFLAGS}"

	# Bug 106530.
	if [[ ${CHOST} == *-linux-gnu ]] ; then
		mycflags="${CFLAGS} -DSVR4"
	fi
	make CFLAGS="${mycflags}" || die
}

src_install() {
	dobin ttyrec ttyplay ttytime || die
	dodoc README
	doman *.1
}
