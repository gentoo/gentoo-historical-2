# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/help2man/help2man-1.29.ebuild,v 1.19 2004/06/24 22:09:44 agriffis Exp $

DESCRIPTION="GNU utility to convert program --help output to a man page"
HOMEPAGE="http://www.gnu.org/software/help2man"
SRC_URI="http://ftp.gnu.org/gnu/help2man/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ppc sparc alpha hppa mips ia64 ppc64"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

src_install(){
	into /usr
	dobin help2man
}

