# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/dvd+rw-tools/dvd+rw-tools-5.13.4.7.4.ebuild,v 1.7 2004/06/24 21:33:16 agriffis Exp $

DESCRIPTION="A set of tools for DVD+RW/-RW drives."
HOMEPAGE="http://fy.chalmers.se/~appro/linux/DVD+RW/"
SRC_URI="http://fy.chalmers.se/~appro/linux/DVD+RW/tools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc ~amd64"

IUSE=""

DEPEND="virtual/glibc
		app-cdr/cdrtools"

src_compile() {
	sed -i -e "s:^CFLAGS=\$(WARN).*:CFLAGS=${CFLAGS}:" \
		-e "s:^CXXFLAGS=\$(WARN).*:CXXFLAGS=${CXXFLAGS} -fno-exceptions:" \
	Makefile.m4 || die
	emake || die
}

src_install() {
	dobin dvd+rw-booktype
	dobin dvd+rw-format
	dobin dvd+rw-mediainfo
	dobin growisofs
	dohtml index.html
	doman growisofs.1
}
