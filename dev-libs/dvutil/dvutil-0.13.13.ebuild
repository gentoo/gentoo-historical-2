# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dvutil/dvutil-0.13.13.ebuild,v 1.5 2004/10/11 13:03:04 dams Exp $

S=${WORKDIR}/dvutil-${PV}
DESCRIPTION="dvutil provides some general C++ utility classes for files, directories, dates, property lists, reference counted pointers, number conversion etc. "
SRC_URI="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvutil/download/dvutil-${PV}.tar.gz"
HOMEPAGE="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvutil/html/"
KEYWORDS="x86 ppc sparc"
LICENSE="GPL-2"
SLOT="0"

IUSE=""
DEPEND="virtual/libc"
RDEPEND=${DEPEND}
PATCHS="${FILESDIR}/0.13.13-gentoo-doc_distdir.patch"

inherit eutils

src_install() {
	epatch ${PATCHS}
	make DESTDIR=${D} install
}
