# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/pth/pth-1.4.1.ebuild,v 1.7 2004/05/26 15:16:54 jhuebel Exp $

inherit gnuconfig

DESCRIPTION="GNU Portable Threads"
HOMEPAGE="http://www.gnu.org/software/pth/"
SRC_URI="ftp://ftp.gnu.org/gnu/pth/pth-1.4.1.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ppc sparc ~amd64"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}

	# update GNU config files
	gnuconfig_update
}	

src_install() {
	einstall || die
	dodoc ANNOUNCE AUTHORS ChangeLog NEWS README THANKS USERS
}
