# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/log4cpp/log4cpp-0.3.4b.ebuild,v 1.6 2004/02/22 09:43:09 dholm Exp $

DESCRIPTION="library of C++ classes for flexible logging to files, syslog, IDSA and other destinations"
HOMEPAGE="http://log4cpp.sourcforge.net/"
SRC_URI="mirror://sourceforge/log4cpp/${PN}-0.3.4b.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ~ppc"

DEPEND="virtual/glibc"

src_compile() {
	econf || die "./configure failed"
	emake || die
}

src_install () {
#	make DESTDIR=${D} install || die
	make prefix=${D}/usr \
		datadir=${D}/usr/share \
		mandir=${D}/usr/share/man \
		docdir=${D}/usr/share/doc/${PF}/html \
		sysconfdir=${D}/etc install || die
	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README THANKS TODO
}
