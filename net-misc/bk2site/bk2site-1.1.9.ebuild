# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/bk2site/bk2site-1.1.9.ebuild,v 1.1 2003/10/12 01:17:45 brandy Exp $

S=${WORKDIR}/${P}

DESCRIPTION="bk2site will transform your Netscape bookmarks file into a yahoo-like website with slashdot-like news."
SRC_URI="mirror://sourceforge/bk2site/${P}.tar.gz"
HOMEPAGE="http://bk2site.sourceforge.net/"
KEYWORDS="~x86 ~sparc"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
}

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	emake CXXFLAGS="${CXXFLAGS}" || die
}

src_install () {
	make DESTDIR=${D} install || die
	insinto /etc/bk2site
	doins indexbase.html newbase.html otherbase.html searchbase.html
	dodoc bk2site.html *.gif
	dodoc README COPYING AUTHORS ChangeLog INSTALL TODO
	exeinto /home/httpd/cgi-bin/bk2site
	doexe *.pl
}
