# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-office/siag/siag-3.5.2.ebuild,v 1.3 2002/08/01 11:58:59 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A free Office package for Linux"
SRC_URI="ftp://siag.nu/pub/siag/${P}.tar.gz"
HOMEPAGE="http://siag.nu/"

DEPEND="virtual/x11
	>=dev-libs/gmp-3.1.1
	>=media-libs/xpm-3.4
	>=x11-misc/mowitz-0.2.1
	>=dev-lang/tcl-8.0.0"
#	>=media-libs/t1lib-1.0.1"

RDEPEND="virtual/x11"
#	>=media-libs/t1lib-1.0.1"

src_compile() {

    local myconf
#Causes segfaults in 3.5.2 on my system...
#    if [ "`use guile`" ]
#    then
#      myconf="$myconf --with-guile"
#    else
#      myconf="$myconf --without-guile"
#    fi
    ./configure --prefix=/usr \
		--with-x \
		--with-xawm="Xaw" \
		--mandir=/use/share/man \
		--host=${CHOST} \
		--with-tcl \
		--with-gmp \
		$myconf || die "Configure failed"
#		--with-t1lib \

    make || die "Make failed"

}

src_install () {

    make DESTDIR=${D} install || die "Install failed"
}

