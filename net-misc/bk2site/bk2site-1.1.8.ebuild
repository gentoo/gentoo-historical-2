# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Jon Nelson <jnelson@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/bk2site/bk2site-1.1.8.ebuild,v 1.2 2002/04/06 06:55:32 jnelson Exp $

S=${WORKDIR}/${P}

DESCRIPTION="bk2site will transform your Netscape bookmarks file into a yahoo-like website with slashdot-like news."
SRC_URI="http://prdownloads.sourceforge.net/bk2site/${P}.tar.gz"
HOMEPAGE="http://bk2site.sourceforge.net/"

DEPEND=""
#RDEPEND=""

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	emake || die
	#make || die
}

src_install () {
	make DESTDIR=${D} install || die
	insinto /etc/bk2site
	doins indexbase.html newbase.html otherbase.html searchbase.html
	dodoc bk2site.html *.gif 
	dodoc README COPYING AUTHORS ChangeLog INSTALL NEWS TODO
	exeinto /home/httpd/cgi-bin/bk2site
	doexe *.pl
}
