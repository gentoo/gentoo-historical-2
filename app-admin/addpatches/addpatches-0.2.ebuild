# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/addpatches/addpatches-0.2.ebuild,v 1.12 2003/07/18 18:56:23 tester Exp $

DESCRIPTION="patch management script"
HOMEPAGE="http://www.gentoo.org"
DEPEND=""
IUSE=""
SRC_URI=""

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc alpha hppa arm ~mips amd64"

RDEPEND="sys-devel/patch"

src_install() {
	dobin ${FILESDIR}/addpatches
}
