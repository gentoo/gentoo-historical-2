# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/crossdev/crossdev-0.9.15-r1.ebuild,v 1.2 2006/05/09 06:52:25 flameeyes Exp $

DESCRIPTION="Gentoo Cross-toolchain generator"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="!>=sys-devel/gcc-config-2
	sys-apps/portage
	app-shells/bash"

src_install() {
	dosbin "${FILESDIR}"/crossdev || die
	dosed "s:GENTOO_PV:${PV}:" /usr/sbin/crossdev
}
