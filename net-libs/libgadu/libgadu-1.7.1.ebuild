# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libgadu/libgadu-1.7.1.ebuild,v 1.2 2007/05/20 20:38:42 drizzt Exp $

inherit eutils libtool

DESCRIPTION="This library implements the client side of the Gadu-Gadu protocol"
HOMEPAGE="http://toxygen.net/libgadu/"
SRC_URI="http://toxygen.net/libgadu/files/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

IUSE="ssl threads"

DEPEND="ssl? ( >=dev-libs/openssl-0.9.6m )"

src_compile() {
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
