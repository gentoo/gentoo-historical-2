# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdegraphics/kdegraphics-2.0.ebuild,v 1.1 2000/11/06 16:19:55 achim Exp $

A=${P}.tar.bz2
S=${WORKDIR}/${P}
DESCRIPTION="KDE 2.0 - Graphics"
SRC_PATH="kde/stable/2.0/distribution/tar/generic/src/${A}"
SRC_URI="ftp://ftp.kde.org/pub/$SRC_PATH
	 ftp://ftp.sourceforge.net/pub/mirrors/$SRC_PATH"

HOMEPAGE="http://www.kde.org"

src_compile() {
    try ./configure --prefix=/opt/kde2 --host=${CHOST} \
		--with-qt-dir=/usr/lib/qt-x11-2.2.1 \
		--with-qt-includes=/usr/lib/qt-x11-2.2.1/include \
		--with-qt-libs=/usr/lib/qt-x11-2.2.1/lib
    try make
}

src_install() {
  try make install DESTDIR=${D}
  dodoc AUTHORS COPYING README ChangeLog
}




