# Copyright 2003-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/dvd+rw-tools/dvd+rw-tools-5.12.4.7.4.ebuild,v 1.1 2003/09/27 20:51:26 weeve Exp $

DESCRIPTION="A set of tools for DVD+RW/-RW drives."
HOMEPAGE="http://fy.chalmers.se/~appro/linux/DVD+RW/"
SRC_URI="http://fy.chalmers.se/~appro/linux/DVD+RW/tools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc"

IUSE=""

DEPEND="virtual/glibc
		app-cdr/cdrtools"

S="${WORKDIR}/${P}"

src_compile() {
	mv Makefile.m4 Makefile.m4.orig
	sed -e "s:^CFLAGS=\$(WARN).*:CFLAGS=${CFLAGS}:" \
		-e "s:^CXXFLAGS=\$(WARN).*:CXXFLAGS=${CXXFLAGS} -fno-exceptions:" \
	Makefile.m4.orig > Makefile.m4 || die
	
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
