# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Ben Lutgens <lamer@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-wm/oroborus/oroborus-2.0.4-r1.ebuild,v 1.1 2001/10/12 00:41:24 hallski Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Yet another window manager"
SRC_URI="http://www.kensden.pwp.blueyonder.co.uk/Oroborus/files/${P}.tar.gz"
HOMEPAGE="http://www.kensden.pwp.blueyonder.co.uk/Oroborus"


DEPEND="virtual/x11"

src_compile() {
	./configure --host=${CHOST}					\
		    --prefix=/usr					\
		    --sysconfdir=/etc/X11/oroborus			\
	 	    --infodir=/usr/share/info				\
		    --mandir=/usr/share/man
	assert
	
	emake || die
}

src_install () {
	make prefix=${D}/usr						\
	     sysconfdir=${D}/etc/X11/oroborus				\
	     infodir=${D}/usr/share/info				\
	     mandir=${D}/usr/share/man					\
	     install || die

	dodoc README INSTALL ChangeLog TODO NEWS AUTHORS example.oroborusrc
}

