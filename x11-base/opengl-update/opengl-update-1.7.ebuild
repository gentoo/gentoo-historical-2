# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-base/opengl-update/opengl-update-1.7.ebuild,v 1.5 2004/06/11 20:19:35 kloeri Exp $

DESCRIPTION="Utility to change the OpenGL interface being used"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ppc sparc ~mips alpha arm ~hppa amd64 ~ia64"
IUSE=""

DEPEND="virtual/glibc"

src_install() {
	newsbin ${FILESDIR}/opengl-update-${PV} opengl-update || die
}
