# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dvenv/dvenv-0.2.2.ebuild,v 1.2 2003/03/13 10:00:30 pvdabeel Exp $

A=dvenv-${PV}.tar.gz
S=${WORKDIR}/dvenv-${PV}
DESCRIPTION="dvenv provides polymorphic tree-structured environments, generalizing the Dv::Util::Props class"
SRC_URI="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvenv/download/${A}"
HOMEPAGE="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvenv/html/"
KEYWORDS="x86 ppc"
LICENSE="GPL-2"
SLOT="0"

IUSE=""
DEPEND="virtual/glibc
	dev-libs/dvutil"
RDEPEND=${DEPEND}

src_install() {
	make prefix=${D}/usr install
}
