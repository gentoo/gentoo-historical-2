# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dvacm4/dvacm4-0.3.1.ebuild,v 1.7 2004/05/31 02:16:05 pvdabeel Exp $

S=${WORKDIR}/${P}
DESCRIPTION="dvacm4 provides autoconf macros used by the dv* C++ utilities"
HOMEPAGE="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvacm4/"
SRC_URI="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvacm4/${P}.tar.gz"

SLOT="4"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc ppc64 ia64 amd64"

IUSE=""
DEPEND="virtual/glibc"
RDEPEND=${DEPEND}

src_install() {
	make DESTDIR=${D} install || die
}
