# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Philippe Namias <pnamias@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeaddons/kdeaddons-2.2.1.ebuild,v 1.2 2001/09/19 17:18:11 danarmak Exp $

S=${WORKDIR}/${P}
DESCRIPTION="KDE ${PV} - Addons"
SRC_PATH="kde/stable/${PV}/src/${P}.tar.bz2"
SRC_URI="ftp://ftp.kde.org/pub/$SRC_PATH
	 ftp://ftp.fh-heilbronn.de/pub/mirrors/$SRC_PATH
	 ftp://ftp.sourceforge.net/pub/mirrors/$SRC_PATH"

HOMEPAGE="http://www.kde.org"

DEPEND=">=kde-base/kdelibs-${PV}
	>=kde-base/kdemultimedia-${PV}
        >=media-libs/libsdl-1.2
	objprelink? ( dev-util/objprelink )"

src_unpack() {

	cd ${WORKDIR}
	unpack ${P}.tar.bz2

}

src_compile() {
    . /etc/env.d/90{kde${PV},qt}
    local myconf
    if [ "`use qtmt`" ]
    then
      myconf="$myconf --enable-mt"
    fi
    if [ "`use mitshm`" ]
    then
      myconf="$myconf --enable-mitshm"
    fi
	if [ "`use objprelink`" ] ; then
	  myconf="$myconf --enable-objprelink"
	fi
    ./configure --host=${CHOST} \
		--with-xinerama \
		$myconf || die
    make || die
}

src_install() {
  make install DESTDIR=${D} || die
  dodoc AUTHORS ChangeLog COPYING README*
}







