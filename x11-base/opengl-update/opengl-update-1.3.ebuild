# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-base/opengl-update/opengl-update-1.3.ebuild,v 1.8 2002/10/04 06:38:01 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Utility to change the OpenGL interface being used."
SRC_URI=""
HOMEPAGE="http://www.gentoo.org/"

SLOT="0"
KEYWORDS="x86 ppc sparc sparc64"
LICENSE="GPL-2"
DEPEND="virtual/glibc"
RDEPEND=$DEPEND

src_install() {
	newsbin ${FILESDIR}/opengl-update-${PV} opengl-update
}

