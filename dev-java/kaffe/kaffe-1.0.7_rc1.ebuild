# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-java/kaffe/kaffe-1.0.7_rc1.ebuild,v 1.1 2002/06/25 01:34:33 karltk Exp $

. /usr/portage/eclass/inherit.eclass
inherit java

S=${WORKDIR}/${P/_/-}
DESCRIPTION="A cleanroom, open source Java VM and class libraries"
SRC_URI="http://www.kaffe.org/ftp/pub/kaffe/testing/v1.0.x/${P/_/-}.tar.gz"
HOMEPAGE="http://www.kaffe.org/"
DEPEND=">=dev-libs/gmp-3.1
        >=media-libs/jpeg-6b
        >=media-libs/libpng-1.2.1
	virtual/glibc
	virtual/x11"
LICENSE="GPL-2"
SLOT="0"

src_unpack() {
	unpack ${A}
}

src_compile() {
	./configure --host=${CHOST} \
		    --prefix=/opt/${P}
	make || die
}

src_install () {
	make DESTDIR=${D} install || die

	set_java_env ${FILESDIR}/${VMHANDLE} || die
}
