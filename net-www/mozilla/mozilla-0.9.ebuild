# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-www/mozilla/mozilla-0.9.ebuild,v 1.2 2001/05/08 03:34:25 achim Exp $

A=mozilla-source-${PV}.tar.gz
S=${WORKDIR}/mozilla
DESCRIPTION=""
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla/releases/mozilla${PV}/src/${A}"
HOMEPAGE="http://www.mozilla.org"
PROVIDE="virtual/x11-web-browser"

DEPEND=">=gnome-base/ORBit-0.5.7
	>=x11-libs/gtk+-1.2.9
	>=sys-libs/zlib-1.1.3
	>=media-libs/jpeg-6b
	>=media-libs/libpng-1.0.9"

src_compile() {

    try ./configure --prefix=/opt/mozilla --host=${CHOST} \
	--with-gtk --disable-tests --disable-debug 
    try make
    try ./configure --prefix=/opt/mozilla --host=${CHOST} \
	--with-gtk --disable-tests --disable-debug 
    try make BUILD_MODULES=psm
    try ./configure --prefix=/opt/mozilla --host=${CHOST} \
	--with-gtk --disable-tests --disable-debug \
	--with-extensions=default,irc
    cd extensions/irc
    try make
}

src_install () {

    dodir /opt/mozilla/include/nspr/{private,obsolete,md}
    cd dist/include
    cp -f *.h ${D}/opt/mozilla/include
    cp -f nspr/*.h ${D}/opt/mozilla/include/nspr
    cp -f nspr/obsolete/*.h ${D}/opt/mozilla/include/nspr/obsolete
    cp -f nspr/private/*.h ${D}/opt/mozilla/include/nspr/private
    cp -f nspr/md/*.h ${D}/opt/mozilla/include/nspr/md

    export MOZILLA_OFFICIAL=1
    export BUILD_OFFICIAL=1
    cd ${S}/xpinstall/packager
    try make
    dodir /opt
    tar xzf ${S}/dist/mozilla-i686-pc-linux-gnu.tar.gz -C ${D}/opt
    mv ${D}/opt/package ${D}/opt/mozilla

    exeinto /usr/bin
    doexe ${FILESDIR}/mozilla
    insinto /etc/env.d
    doins ${FILESDIR}/10mozilla
    dodoc LEGAL LICENSE README/mozilla/README*


}

