# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/jfsutils/jfsutils-1.0.23.ebuild,v 1.4 2002/10/20 18:54:50 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="IBM's Journaling Filesystem (JFS) Utilities"
SRC_URI="http://www10.software.ibm.com/developer/opensource/jfs/project/pub/${P}.tar.gz"
HOMEPAGE="http://www-124.ibm.com/developerworks/oss/jfs/index.html"
KEYWORDS="~x86 -ppc"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc"

src_compile() {
	./configure --prefix=/usr \
		    --sbindir=/sbin \
		    --host=${CHOST} \
		    --sysconfdir=/etc \
		    --mandir=/usr/share/man || die

	emake || die
}

src_install () {
	make DESTDIR=${D} install || die 
	
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README
}

