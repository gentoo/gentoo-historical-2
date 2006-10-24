# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/build-docbook-catalog/build-docbook-catalog-1.2.ebuild,v 1.15 2006/10/24 09:58:36 uberlord Exp $

DESCRIPTION="DocBook XML catalog auto-updater"
HOMEPAGE="http://unknown/"
SRC_URI="mirror://gentoo/${P}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ~ppc-macos ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}

src_install() {
	newbin ${P} ${PN} || die
}
