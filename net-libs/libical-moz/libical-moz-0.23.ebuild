# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Geert Bevin <gbevin@theleaf.be>
# $Header: /var/cvsroot/gentoo-x86/net-libs/libical-moz/libical-moz-0.23.ebuild,v 1.1 2002/01/07 12:42:47 gbevin Exp $

S=${WORKDIR}/libical-0.23-moz
DESCRIPTION="libical is used by the mozilla calendar component"
SRC_URI="http://www.oeone.com/files/libical-0.23-moz.tar.gz"
HOMEPAGE="http://www.mozilla.org/projects/calendar/installation.html"

DEPEND="virtual/glibc"

RDEPEND="virtual/glibc"
	
src_unpack() {

	unpack ${A}

}

src_compile() {

	cd ${S}
	./autogen.sh --prefix=/usr --disable-python-bindings || die
	emake || die

}

src_install () {

	make DESTDIR=${D} install || die

}

