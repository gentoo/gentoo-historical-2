# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/mirrorselect/mirrorselect-0.89.ebuild,v 1.3 2005/04/19 22:27:40 plasmaroo Exp $

# I should really try remove the gawk dependancy and replace with cut or something!

DESCRIPTION="Tool to help select distfiles mirrors for Gentoo"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${PF}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha arm hppa amd64 ppc64 s390 ia64"
IUSE=""

RDEPEND=">=dev-util/dialog-0.7
	sys-apps/grep
	sys-apps/sed
	sys-apps/gawk
	net-misc/wget
	net-analyzer/netselect"

S=${WORKDIR}

src_install() {
	dosbin ${S}/mirrorselect || die
}
