# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/addpatches/addpatches-0.2.ebuild,v 1.4 2002/12/09 04:17:34 manson Exp $

DESCRIPTION="patch management script"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc  alpha"

RDEPEND="sys-devel/patch"

src_install() {
	dobin ${FILESDIR}/addpatches
}
