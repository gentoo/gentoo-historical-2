# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/siag/siag-3.5.2-r2.ebuild,v 1.6 2002/10/04 04:59:44 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A free Office package for Linux"
SRC_URI="ftp://siag.nu/pub/siag/${P}.tar.gz"
HOMEPAGE="http://siag.nu/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="virtual/x11
	>=dev-libs/gmp-3.1.1
	>=media-libs/xpm-3.4
	>=x11-misc/mowitz-0.2.1
	>=dev-lang/tcl-8.0.0"
#	>=media-libs/t1lib-1.0.1"

RDEPEND="virtual/x11"
#	>=media-libs/t1lib-1.0.1"

if [ -n "`use kde`" ]; then inherit kde-functions; set-kdedir 3; fi

src_unpack() {

	unpack ${A}
	cd ${S}

	if [ -z "`use kde`" ]; then
		einfo "Not using KDE"
		for file in `find . -iname "Makefile.*"`; do
			grep -v "kdeinst" ${file} >${file}.hacked && \
			mv ${file}.hacked ${file} || die "Hacking of ${file} failed"
		done
	else
		einfo "Using KDE"
		sed -e "s:VERBOSE=no:VERBOSE=no\nKDEDIR=${D}/${PREFIX}:" common/kdeinst \
		    > common/kdeinst.hacked && \
		mv common/kdeinst.hacked common/kdeinst || die "Hacking of kdeinst failed"
	fi
}

src_compile() {

	local myconf
#Causes segfaults in 3.5.2 on my system...
#    if [ "`use guile`" ]
#    then
#      myconf="${myconf} --with-guile"
#    else
#      myconf="${myconf} --without-guile"
#    fi
	./configure --prefix=/usr \
		    --with-x \
		    --with-xawm="Xaw" \
		    --mandir=/usr/share/man \
		    --host=${CHOST} \
		    --with-tcl \
		    --with-gmp \
		    ${myconf} || die "Configure failed"
#		--with-t1lib \

	make || die "Make failed"
}

src_install () {

	if [ -n "`use kde`" ]; then
		dodir ${PREFIX}
	fi

	make DESTDIR=${D} install || die "Install failed"

	dodoc AUTHORS COPYING ChangeLog FILES NEWS NLS README
}
