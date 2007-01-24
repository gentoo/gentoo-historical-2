# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/dvd+rw-tools/dvd+rw-tools-7.0.ebuild,v 1.10 2007/01/24 02:21:28 genone Exp $

inherit eutils toolchain-funcs

DESCRIPTION="A set of tools for DVD+RW/-RW drives"
HOMEPAGE="http://fy.chalmers.se/~appro/linux/DVD+RW/"
SRC_URI="http://fy.chalmers.se/~appro/linux/DVD+RW/tools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 sh sparc x86"
IUSE=""

DEPEND="virtual/cdrtools"

src_compile() {
	sed -i \
		-e "s:^CFLAGS=\$(WARN).*:CFLAGS=${CFLAGS}:" \
		-e "s:^CXXFLAGS=\$(WARN).*:CXXFLAGS=${CXXFLAGS} -fno-exceptions:" \
		Makefile.m4 || die
	emake CC=$(tc-getCC) CXX=$(tc-getCXX) || die
}

src_install() {
	einstall || die
	dohtml index.html
}

pkg_postinst() {
	elog
	elog "When you run growisofs if you receive:"
	elog "unable to anonymously mmap 33554432: Resource temporarily unavailable"
	elog "error message please run 'ulimit -l unlimited'"
	elog
}
