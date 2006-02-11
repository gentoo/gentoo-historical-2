# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/fribidi/fribidi-0.10.7.ebuild,v 1.1 2006/02/11 17:14:52 matsuu Exp $

DESCRIPTION="A free implementation of the unicode bidirectional algorithm"
HOMEPAGE="http://fribidi.org/"
SRC_URI="http://fribidi.org/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	econf || die
	emake || die "emake failed"
	make test || die "make test failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README ChangeLog THANKS TODO
}
