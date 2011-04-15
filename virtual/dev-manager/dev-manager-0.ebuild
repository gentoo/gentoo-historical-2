# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/dev-manager/dev-manager-0.ebuild,v 1.1 2011/04/15 21:46:03 ulm Exp $

DESCRIPTION="Virtual for the device filesystem manager"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="|| ( sys-fs/udev
		sys-fs/devfsd
		sys-fs/static-dev
		sys-freebsd/freebsd-sbin )"
