# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/crossdev/crossdev-0.9.6.ebuild,v 1.4 2005/07/10 00:47:01 vapier Exp $

DESCRIPTION="Gentoo Cross-toolchain generator"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND="sys-apps/portage
	app-shells/bash
	sys-apps/coreutils"

src_install() {
	dosbin "${FILESDIR}"/crossdev || die
	dosed "s:GENTOO_PV:${PV}:" /usr/sbin/crossdev
}
