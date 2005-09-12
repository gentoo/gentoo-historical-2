# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/localepurge/localepurge-0.2-r2.ebuild,v 1.2 2005/09/12 18:13:06 grobian Exp $

DESCRIPTION="Script to recover diskspace wasted for unneeded locale files and localized man pages"
HOMEPAGE="http://www.gentoo.org/~bass/"
SRC_URI="mirror://gentoo/${P}-r1.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ~ppc-macos ppc64 s390 sh sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-shells/bash"

S=${WORKDIR}/${PN}

src_install() {
	insinto /var/cache/localepurge
	doins defaultlist
	dosym defaultlist /var/cache/localepurge/localelist
	insinto /etc
	doins locale.nopurge
	dobin localepurge || die
	doman localepurge.8
}
