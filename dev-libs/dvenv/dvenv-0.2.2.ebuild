# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dvenv/dvenv-0.2.2.ebuild,v 1.1 2003/03/06 18:54:14 pvdabeel Exp $

A=dvenv-${PV}.tar.gz
S=${WORKDIR}/dvenv-${PV}
DESCRIPTION="dvenv provides polymorphic tree-structured environments, generalizing the Dv::Util::Props class"
SRC_URI="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvenv/download/${A}"
HOMEPAGE="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvenv/html/"
KEYWORDS="x86 ppc"
LICENSE="GPL2"
SLOT="0"

DEPEND="virtual/glibc
	dev-libs/dvutil"

src_install() {
	make prefix=${D}/usr install
}
