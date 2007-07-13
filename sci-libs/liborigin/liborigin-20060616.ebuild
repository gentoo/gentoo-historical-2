# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/liborigin/liborigin-20060616.ebuild,v 1.3 2007/07/13 06:57:50 mr_bones_ Exp $

DESCRIPTION="A library for reading OriginLab OPJ project files"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/liborigin/"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

SLOT="0"
IUSE=""

DEPEND=""

src_compile() {
	# the Makefile.LINUX is very basic, and *both* (and the only) "action" lines
	# need to be adjusted. It is easier to simply build stuff in a proper way
	# directly here.
	g++ -shared -Wl,-soname,liborigin.so.0 ${CXXFLAGS} -fPIC OPJFile.cpp \
		-o liborigin.so.0.0.1
	g++ -o opj2dat ${CXXFLAGS} opj2dat.cpp OPJFile.cpp
	ln -s liborigin.so.0.0.1 liborigin.so.0
	ln -s liborigin.so.0 liborigin.so
}

src_install() {
	dolib liborigin.so*
	dobin opj2dat
	dodoc COPYING README ws4.opj
	insinto /usr/include
	doins OPJFile.h
}
