# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-im/psi/psi-0.8.4.ebuild,v 1.3 2002/02/03 21:51:15 danarmak Exp $

S=${WORKDIR}/${P}
SRC_URI="http://www.affinix.com/~justin/programs/psi/${P}.tar.bz2"
DESCRIPTION="QT 3.x Jabber Client, with Licq-like interface"
HOMEPAGE="http://www.affinix.com/~justin/programs/psi/"

DEPEND="virtual/glibc
	=x11-libs/qt-3*
	ssl? ( >=dev-libs/openssl-0.9.b )"

src_compile() {
	
	export QTDIR="/usr/qt/3"
	export QMAKESPEC="linux-g++"
	cd ${S}/src
	mv common.cpp common.cpp.orig
	sed -e 's:PATH_BASE = "/usr/local/psi":PATH_BASE = "/usr/share/psi":' common.cpp.orig | cat > common.cpp
	/usr/qt/3/bin/qmake psi.pro || die
	emake || die
	mv psi ${S}
	cd ${S}

}

src_install() {

	# We do not use the ./install method, we do it manually ##
	mkdir -p ${D}/usr/bin
	mkdir -p ${D}/usr/share/psi/image
	mkdir -p ${D}/usr/share/psi/iconsets
	mkdir -p ${D}/usr/share/psi/iconsets/cosmic
	mkdir -p ${D}/usr/share/psi/iconsets/icq2
	mkdir -p ${D}/usr/share/psi/iconsets/licq

	cd ${S}
	cp image/*.png ${D}/usr/share/psi/image/
	cp iconsets/cosmic/* ${D}/usr/share/psi/iconsets/cosmic/
	cp iconsets/icq2/* ${D}/usr/share/psi/iconsets/icq2/
	cp iconsets/licq/* ${D}/usr/share/psi/iconsets/licq/
	cp psi ${D}/usr/share/psi/
	cp README ${D}/usr/share/psi/
	cp COPYING ${D}/usr/share/psi/
	ln -sf /usr/share/psi/psi ${D}/usr/bin/psi

}
