# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/swig/swig-1.3_alpha4.ebuild,v 1.3 2000/11/15 16:33:15 achim Exp $

P=swig1.3a4
A=${P}.tar.gz
S=${WORKDIR}/SWIG1.3a4
DESCRIPTION="Simplified wrapper and interface generator"
SRC_URI="http://download.sourceforge.net/swig/${A}"
HOMEPAGE="http://www.swig.org"

DEPEND=">=sys-devel/gcc-2.95.2
	>=sys-libs/glibc-2.1.3
	|| ( >=sys-devel/python-basic-1.5.2 >=dev-lang/python-1.5.2 )
	>=dev-lang/jdk-1.2.2
	>=dev-util/guile-1.4"

# This does not work	>=dev-lang/tcl-tk-8.1.1

src_compile() {

    cd ${S}
    unset CXXFLAGS
    unset CFLAGS
    try ./configure --prefix=/usr --host=${CHOST} \
	--with-doc=html --with-tcllib=/usr/lib/tcl8.1
    try make

}

src_install () {

    cd ${S}
    try make prefix=${D}/usr install

}

