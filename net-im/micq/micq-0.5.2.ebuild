# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/micq/micq-0.5.2.ebuild,v 1.1 2006/11/07 05:48:52 usata Exp $

IUSE="tcltk ssl"

SRC_URI="http://www.micq.org/source/${P}.tgz"
DESCRIPTION="ICQ text-mode client with many features"
HOMEPAGE="http://www.micq.org/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
DEPEND="virtual/libc
	ssl? ( >=net-libs/gnutls-0.8.10
		dev-libs/openssl )
	tcltk? ( dev-lang/tcl )"

src_compile() {

	econf `use_enable tcltk tcl` \
		`use_enable ssl` \
		|| die "econf failed"
	emake || die
}

src_install() {

	make DESTDIR=${D} install || die

	dodoc COPYING AUTHORS ChangeLog FAQ INSTALL NEWS README TODO
}
