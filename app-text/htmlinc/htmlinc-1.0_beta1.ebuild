# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/htmlinc/htmlinc-1.0_beta1.ebuild,v 1.7 2003/01/08 23:23:46 hanno Exp $

DESCRIPTION="HTML Include System by Ulli Meybohm"
HOMEPAGE="http://www.meybohm.de/"
SRC_URI="http://meybohm.de/files/${PN}.tar.gz"
IUSE=""
KEYWORDS="x86 sparc"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc"
S=${WORKDIR}/htmlinc

src_unpack() {
	unpack ${A}
	patch -p0 < ${FILESDIR}/htmlinc-gcc3-gentoo.patch || die "could not patch"
}

src_compile() {
	emake CFLAGS="${CXXFLAGS} -Wall" || die
}

src_install() {
	dobin htmlinc
}
