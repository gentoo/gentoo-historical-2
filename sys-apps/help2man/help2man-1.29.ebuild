# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/help2man/help2man-1.29.ebuild,v 1.2 2003/02/05 10:26:10 seemant Exp $

DESCRIPTION="GNU utility to convert program --help output to a man page"
HOMEPAGE="http://www.gnu.org/software/help2man"
SRC_URI="http://ftp.gnu.org/gnu/help2man/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"
IUSE=""

DEPEND="sys-devel/perl"
RDEPEND="${DEPEND}"

src_install(){
	into /usr
	dobin help2man
}

