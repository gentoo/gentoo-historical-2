# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-base/opengl-update/opengl-update-1.5.ebuild,v 1.11 2004/06/28 16:58:44 agriffis Exp $

DESCRIPTION="Utility to change the OpenGL interface being used."
SRC_URI=""
HOMEPAGE="http://www.gentoo.org/"

KEYWORDS="x86 ppc sparc alpha hppa amd64 ia64 mips"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/libc"


src_install() {
	newsbin ${FILESDIR}/opengl-update-${PV} opengl-update
}

