# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebase/kdebase-2.0-r2.ebuild,v 1.2 2000/11/27 22:48:59 achim Exp $

A="${P}.tar.bz2"
S=${WORKDIR}/${P}
DESCRIPTION="KDE 2.0 - Base"
SRC_PATH="kde/stable/2.0/distribution/tar/generic/src/${A}"
SRC_URI="ftp://ftp.kde.org/pub/$SRC_PATH
	 ftp://ftp://ftp.twoguys.org/pub/$SRC_PATH
	 ftp://ftp.sourceforge.net/pub/mirrors/$SRC_PATH"
HOMEPAGE="http://www.kde.org/"

DEPEND=">=kde-base/kdelibs-2.0
	>=x11-libs/openmotif-MLI-2.1.30"

src_compile() {

    export CFLAGS="${CFLAGS} -I/usr/X11R6/include"
    export CXXFLAGS="${CXXFLAGS} -I/usr/X11R6/include"
    export CPPFLAGS="${CXXFLAGS} -I/usr/X11R6/include"
    try ./configure --prefix=/opt/kde2 --host=${CHOST} --with-shadow --with-x \
		--with-pam=yes --with-ldap \
		--with-qt-dir=/usr/lib/qt \
		--with-qt-includes=/usr/lib/qt/include \
		--with-qt-libs=/usr/lib/qt/lib
    try make
}


src_install() {
  try make install DESTDIR=${D}
  dodoc AUTHORS ChangeLog README*
}


