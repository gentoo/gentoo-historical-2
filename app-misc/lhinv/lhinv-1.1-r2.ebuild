# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/lhinv/lhinv-1.1-r2.ebuild,v 1.3 2002/10/19 15:48:49 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Linux Hardware Inventory"
SRC_URI="mirror://sourceforge/lhinv/${P}.tar.gz"
HOMEPAGE="http://lhinv.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

RDEPEND="sys-devel/perl"

src_compile() {													 
	cd ${S}/cgi
	cp w3hinv w3hinv.orig
	sed -e "s:^my \$HINV =.*:my \$HINV =\"/usr/bin/lhinv\";:" \
		w3hinv.orig > w3hinv
	cd ..
	make local || die
}

src_install() {															 
	cd ${S}
	into /usr
	dobin lhinv
	doman lhinv.1
	dodoc AUTHORS BUGS CHANGELOG COPYING README TODO
	newdoc cgi/README README.cgi
	insinto /home/httpd/cgi-bin
	insopts -m 755 
	doins cgi/w3hinv
}
