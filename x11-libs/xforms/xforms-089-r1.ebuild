# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/x11-libs/xforms/xforms-089-r1.ebuild,v 1.1 2002/06/08 02:21:53 gerk Exp $

if [ ${ARCH} = "x86" ] ; then
	MY_P="bxform-${PV}-glibc2.1"
	MY_D="linux-i386/elf"
	MY_F=${MY_P}
else
	MY_P="bxform-${PV}-glibc2.1-ppc"
	MY_D="linuxppc"
	MY_F="bxform-${PV}-glibc2.1"
fi

S=${WORKDIR}/${PN}
DESCRIPTION="A GUI Toolkit based on Xlib"
SRC_URI="ftp://ncmir.ucsd.edu/pub/xforms/${MY_D}/${MY_F}.tgz"
HOMEPAGE="http://world.std.com/~xforms/"
SLOT="0"
DEPEND="virtual/x11"
RDEPEND=""
LICENSE=GPL

src_compile() {
	make || die
}

src_install () {

	into /usr/X11R6
	dolib FORMS/libforms.{a,so.*}
	dosym /usr/X11R6/lib/libforms.so.0.89 /usr/X11R6/lib/libforms.so
	insinto /usr/X11R6/include
	doins FORMS/forms.h
	doman FORMS/xforms.5
}

