# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/source-highlight/source-highlight-1.8.ebuild,v 1.4 2004/06/25 02:46:58 agriffis Exp $

IUSE=""

DESCRIPTION="Generate highlighted source code as an (x)html document"
HOMEPAGE="http://www.gnu.org/software/src-highlite/source-highlight.html"
SRC_URI="ftp://ftp.gnu.org/gnu/src-highlite/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 ~amd64 ~ppc"
SLOT="0"

DEPEND="sys-apps/gawk
	sys-apps/grep
	sys-devel/bison
	sys-devel/gcc
	sys-devel/flex
	virtual/glibc"

RDEPEND="virtual/glibc"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	cd ${S}/src
	dobin source-highlight cpp2html java2html source-highlight-cgi
	dodir /usr/share/source-highlight
	insinto /usr/share/source-highlight
	doins tags.j2h tags2.j2h

	cd ${S}/doc
	dohtml *.html *.css *.java
	doman source-highlight.1

	dodoc AUTHORS ChangeLog COPYING CREDITS INSTALL \
		NEWS README THANKS TODO.txt
}

