# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/mirrorselect/mirrorselect-0.2.ebuild,v 1.3 2003/02/27 16:24:43 gerk Exp $

DESCRIPTION="Tool to help select distfiles mirrors for Gentoo"
SRC_URI=""
HOMEPAGE=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc ~alpha ~mips hppa"

RDEPEND=">=dev-util/dialog-0.7
        sys-apps/grep
    	sys-apps/sed
	net-analyzer/netselect
        sys-devel/perl"

src_install() {
	dosbin ${FILESDIR}/mirrorselect
}

