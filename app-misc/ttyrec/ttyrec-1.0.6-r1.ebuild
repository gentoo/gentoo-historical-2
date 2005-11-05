# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ttyrec/ttyrec-1.0.6-r1.ebuild,v 1.1 2005/11/05 04:08:25 matsuu Exp $

DESCRIPTION="tty recorder"
HOMEPAGE="http://namazu.org/~satoru/ttyrec/"
SRC_URI="http://namazu.org/~satoru/ttyrec/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc-macos ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	local mycflags
	mycflags="${CFLAGS}"

	# Bug 106530.
	if ! use x86-fbsd && ! use ppc-macos; then
		mycflags="${CFLAGS} -DSVR4"
	fi
	make CFLAGS="${mycflags}" || die
}

src_install() {
	dobin ttyrec ttyplay ttytime || die
	dodoc README
	doman *.1
}
