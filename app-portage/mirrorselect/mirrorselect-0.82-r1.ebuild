# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/mirrorselect/mirrorselect-0.82-r1.ebuild,v 1.3 2003/10/27 09:44:27 gmsoft Exp $

DESCRIPTION="Tool to help select distfiles mirrors for Gentoo"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${PF}.tbz2"
S=${WORKDIR}/

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc ~alpha ~mips hppa ~amd64"

RDEPEND=">=dev-util/dialog-0.7
	sys-apps/grep
	sys-apps/sed
	sys-apps/gawk
	net-misc/wget
	net-analyzer/netselect"

src_install() {
	dosbin ${S}/mirrorselect
}
