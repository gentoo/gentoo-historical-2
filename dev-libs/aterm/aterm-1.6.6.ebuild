# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/aterm/aterm-1.6.6.ebuild,v 1.6 2002/10/05 05:39:10 drobbins Exp $

IUSE="java"

S=${WORKDIR}/${P}
DESCRIPTION="ATerm tree-handling library"
SRC_URI="http://www.cwi.nl/projects/MetaEnv/aterm/${P}.tar.gz"
HOMEPAGE="http://www.cwi.nl/projects/MetaEnv/aterm/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 sparc sparc64"

DEPEND="java? ( virtual/jdk )"

src_compile() {
	local myconf
	use java && myconf="${myconf} --with-java"
	
	econf \
		--with-gcc \
		${myconf} || die "./configure failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING ChangeLog NEWS README
}
