# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/aterm/aterm-1.6.7.ebuild,v 1.10 2004/05/15 02:53:37 kloeri Exp $

DESCRIPTION="ATerm tree-handling library"
HOMEPAGE="http://www.cwi.nl/projects/MetaEnv/aterm/"
SRC_URI="http://www.cwi.nl/projects/MetaEnv/aterm/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ~ppc sparc alpha ~ia64"
IUSE="java"

DEPEND="java? ( virtual/jdk )"

src_compile() {
	local myconf
	use java && myconf="${myconf} --with-java"

	econf \
		--with-gcc \
		${myconf} || die "./configure failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog NEWS README
}
