# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/atool/atool-0.25.0.ebuild,v 1.2 2003/02/13 05:52:50 vapier Exp $

DESCRIPTION="script for managaging file archives of various types (atr,tar+gzip,zip,etc)"
SRC_URI="http://www.student.lu.se/~nbi98oli/src/${P}.tar.gz"
HOMEPAGE="http://www.student.lu.se/~nbi98oli/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

DEPEND="sys-devel/perl"

src_install() {
	dobin acat adiff als apack atool aunpack
	dodoc ChangeLog TODO README COPYING
	doman atool.1
}
