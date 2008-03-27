# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ltrace/ltrace-0.4-r1.ebuild,v 1.10 2008/03/27 16:39:54 armin76 Exp $

inherit eutils autotools

MY_P="${P/-/_}"
DEB_P="${MY_P}-1"

DESCRIPTION="trace library calls made at runtime"
HOMEPAGE="http://packages.debian.org/unstable/utils/ltrace"
SRC_URI="mirror://debian/pool/main/l/ltrace/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/l/ltrace/${DEB_P}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~ia64 ~mips ppc sparc x86"
IUSE=""

DEPEND="dev-libs/elfutils"

src_unpack() {
	unpack ${A}
	epatch "${WORKDIR}"/${DEB_P}.diff
	cd "${S}"
	epatch "${FILESDIR}/0.4-cross-compile.patch"
	epatch "${FILESDIR}/0.4-summary.patch"
	epatch "${FILESDIR}/0.4-parallel-make.patch"
	eautoconf
}

src_install() {
	make STRIPPROG=echo DESTDIR="${D}" docdir=/usr/share/doc/${PF}  install || die "make install failed"
}
