# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Philippe Namias <pnamias@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeutils/kdeutils-2.2.ebuild,v 1.2 2001/08/22 11:29:04 danarmak Exp $

S=${WORKDIR}/${P}
DESCRIPTION="KDE ${PV} - Utilities"
SRC_PATH="kde/stable/${PV}/src/${P}.tar.bz2"
SRC_URI="ftp://ftp.kde.org/pub/$SRC_PATH
	 ftp://ftp.fh-heilbronn.de/pub/mirrors/$SRC_PATH
	 ftp://ftp.sourceforge.net/pub/mirrors/$SRC_PATH
	 http://www.research.att.com/~leonb/objprelink/kde-admin-acinclude.patch"

HOMEPAGE="http://www.kde.org/"

DEPEND=">=kde-base/kdelibs-${PV}
	objprelink? ( dev-util/objprelink )"

RDEPEND="$DEPEND"

src_compile() {
	if [ "`use objprelink`" ] ; then
	  myconf="--enable-objprelink"
	fi
    QTBASE=/usr/X11R6/lib/qt
    try ./configure --prefix=${KDEDIR} --host=${CHOST} \
                --with-qt-dir=$QTBASE --with-xinerama $myconf
    try make
}

src_install() {
  try make install DESTDIR=${D}
  dodoc AUTHORS COPYING README
}
