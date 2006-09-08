# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libgadu/libgadu-20050719.ebuild,v 1.9 2006/09/08 19:29:57 corsair Exp $

inherit eutils libtool

DESCRIPTION="This library implements the client side of the Gadu-Gadu protocol"
HOMEPAGE="http://dev.null.pl/ekg"
SRC_URI="http://dev.gentoo.org/~sekretarz/distfiles/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ~ppc64 ~sparc x86"

IUSE="ssl threads"

DEPEND="ssl? ( >=dev-libs/openssl-0.9.6m )"

src_compile() {
	aclocal -I m4
	autoheader
	autoconf
	elibtoolize
	econf \
	    --enable-shared \
	    `use_with threads pthread` \
	    `use_with ssl openssl` \
	     || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	einstall || die
}
