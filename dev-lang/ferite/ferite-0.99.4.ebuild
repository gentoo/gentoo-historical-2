# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ferite/ferite-0.99.4.ebuild,v 1.2 2002/07/11 06:30:20 drobbins Exp $

S=${WORKDIR}/${P}

DESCRIPTION="ferite is a scripting engine and language written in c for complete portability."

SRC_URI="http://telia.dl.sourceforge.net/sourceforge/ferite/${P}.tar.gz"
HOMEPAGE="http://www.ferite.org/"

DEPEND="virtual/glibc
		dev-libs/libpcre
		dev-libs/libxml2"
SLOT="1"

src_compile() {
	./configure --host=${CHOST} \
		    --prefix=/usr \
		    --infodir=/usr/share/info \
		    --mandir=/usr/share/man || die

	emake || die
}

src_install() {
	make prefix=${D}/usr \
	     infodir=${D}/usr/share/info \
	     mandir=${D}/usr/share/man \
	     install || die
    
	dodoc AUTHORS ChangeLog COPYING README* INSTALL NEWS

	dohtml -r docs
}
