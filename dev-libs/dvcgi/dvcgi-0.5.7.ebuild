# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dvcgi/dvcgi-0.5.7.ebuild,v 1.1 2003/03/06 18:54:14 pvdabeel Exp $

A=dvcgi-${PV}.tar.gz
S=${WORKDIR}/dvcgi-${PV}
DESCRIPTION="dvcgi provides a C++ interface for C++ cgi programs"
SRC_URI="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvcgi/download/${A}"
HOMEPAGE="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvcgi/html/"
KEYWORDS="x86 ppc"
LICENSE="GPL2"
SLOT="0"

DEPEND="virtual/glibc
	dev-libs/dvutil
	dev-libs/dvnet"

src_install() {
	make prefix=${D}/usr install
}
