# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesupport/kdesupport-2.0.ebuild,v 1.1 2000/10/29 20:42:03 achim Exp $

A=${P}.tar.bz2
S=${WORKDIR}/${P}
DESCRIPTION="KDE 2.0 - Support"
SRC_PATH="kde/stable/2.0/distribution/tar/generic/src/${A}"
SRC_URI="ftp://ftp.kde.org/pub/$SRC_PATH
	 ftp://ftp.twoguys.org/pub/$SRC_PATH
	 ftp://ftp.sourceforge.net/pub/mirrors/$SRC_PATH"

HOMEPAGE="http://www.kde.org/"

src_compile() {
    try ./configure --prefix=/opt/kde2 --host=${CHOST} --enable-threads \
		--without-audiofile \
		--with-qt-dir=/usr/lib/qt-x11-2.2.1 \
		--with-qt-includes=/usr/lib/qt-x11-2.2.1/include \
		--with-qt-libs=/usr/lib/qt-x11-2.2.1/lib
    try make
}


src_install() {
  try make install DESTDIR=${D}
  dodoc AUTHORS ChangeLog COPYING README
}


