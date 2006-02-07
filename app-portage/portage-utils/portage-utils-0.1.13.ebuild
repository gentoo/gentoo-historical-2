# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/portage-utils/portage-utils-0.1.13.ebuild,v 1.8 2006/02/07 02:03:04 vapier Exp $

inherit toolchain-funcs

DESCRIPTION="small and fast portage helper tools written in C"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc ~x86"
IUSE=""

DEPEND=""

src_install() {
	dobin q || die "dobin failed"
	doman man/*.[0-9]
	for applet in $(<applet-list) ; do
		dosym q /usr/bin/${applet}
	done
}
