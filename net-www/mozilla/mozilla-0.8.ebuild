# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-www/mozilla/mozilla-0.8.ebuild,v 1.1 2001/02/16 17:49:05 achim Exp $

A=mozilla-source-${PV}.tar.gz
S=${WORKDIR}/mozilla
DESCRIPTION=""
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla/releases/mozilla${PV}/src/${A}"
HOMEPAGE="http://www.mozilla.org"
PROVIDE="virtual/x11-web-browser"

DEPEND=">=gnome-base/ORBit-0.5.6
	>=x11-libs/gtk+-1.2.8
	>=sys-libs/zlib-1.1.3
	>=media-libs/jpeg-6b
	>=media-libs/libpng-1.0.7"

src_compile() {

    cd ${S}
    try ./configure --prefix=/opt/mozilla --host=${CHOST} \
	--with-gtk	-enable-mathml --enable-svg 
    try make

}

src_install () {

    cd ${S}
    export MOZILLA_OFFICIAL=1
    export BUILD_OFFICIAL=1
    cd ${S}/xpinstall/packager
    try make
    dodir /opt
    tar xzf ${S}/dist/mozilla-i686-pc-linux-gnu.tar.gz -C ${D}/opt
    mv ${D}/opt/package ${D}/opt/mozilla
    dodoc LEGAL LICENSE README/mozilla/README*


}

