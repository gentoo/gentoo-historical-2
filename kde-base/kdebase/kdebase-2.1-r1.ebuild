# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebase/kdebase-2.1-r1.ebuild,v 1.2 2001/03/09 10:26:59 achim Exp $

V="2.1"
A="${PN}-${V}.tar.bz2"
S=${WORKDIR}/${PN}-${V}
DESCRIPTION="KDE 2.1 - Base"
SRC_PATH="kde/stable/2.1/distribution/tar/generic/src/${A}"
SRC_URI="ftp://ftp.kde.org/pub/$SRC_PATH
	 ftp://ftp://ftp.twoguys.org/pub/$SRC_PATH
	 ftp://ftp.sourceforge.net/pub/mirrors/$SRC_PATH"
HOMEPAGE="http://www.kde.org/"

DEPEND=">=kde-base/kdelibs-${V}
	ldap? ( >=net-nds/openldap-1.3 )
	pam? ( >=sys-libs/pam-0.73 )
	motif? ( >=x11-libs/openmotif-2.1.30 )"

src_compile() {
    local myconf
    if [ "`use ldap`" ]
    then
      myconf="--with-ldap"
    fi
    if [ "`use pam`" ]
    then
      myconf="$myconf --with-pam=yes"
    else
      myconf="$myconf --with-shadow"
    fi
    if [ "`use qtmt`" ]
    then
      myconf="$myconf --enable-mt"
    fi
    if [ "`use mitshm`" ]
    then
      myconf="$myconf --enable-mitshm"
    fi
    if [ -z "`use motif`" ]
    then
      myconf="$myconf --without-motif"
    fi
    QTBASE=/usr/X11R6/lib/qt
    export CFLAGS="${CFLAGS} -I/usr/X11R6/include"
    export CXXFLAGS="${CXXFLAGS} -I/usr/X11R6/include"
    try ./configure --prefix=/opt/kde${V} --host=${CHOST} --with-x \
		 ${myconf} \
		--with-qt-dir=$QTBASE 
    try make
}


src_install() {
  try make install DESTDIR=${D}
  dodoc AUTHORS ChangeLog README*
}


