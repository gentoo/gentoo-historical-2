# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libghttp/libghttp-1.0.8.ebuild,v 1.1 2000/12/21 08:22:28 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="libghttp"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/"${A}
HOMEPAGE="http://www.gnome.org/"

DEPEND=">=sys-libs/glibc-2.1.3"

src_compile() {                           
	cd ${S}
	try ./configure --host=${CHOST} --prefix=/opt/gnome 
	try make
}

src_install() {                               
	cd ${S}
	try make prefix=${D}/opt/gnome install
	dodoc AUTHORS COPYING* ChangeLog README NEWS TODO
	docinto html
	dodoc doc/ghttp.html
}

pkg_postinst() {
	ldconfig -r ${ROOT}

}
