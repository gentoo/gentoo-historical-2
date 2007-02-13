# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/init/init-0.ebuild,v 1.6 2007/02/13 02:37:28 josejx Exp $

DESCRIPTION="Virtual for various init implementations"
HOMEPAGE="http://www.gentoo.org/proj/en/base/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 m68k ~mips ppc ppc64 s390 sh sparc ~sparc-fbsd ~x86 ~x86-fbsd"

RDEPEND="kernel_linux? ( || ( >=sys-apps/sysvinit-2.86-r6 sys-process/runit ) )
	kernel_FreeBSD? ( sys-freebsd/freebsd-sbin )"
DEPEND=""
