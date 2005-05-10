# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/popt/popt-1.7-r1.ebuild,v 1.21 2005/05/10 22:50:15 vapier Exp $

inherit libtool eutils flag-o-matic

DESCRIPTION="Parse Options - Command line parser"
HOMEPAGE="http://www.rpm.org/"
SRC_URI="ftp://ftp.rpm.org/pub/rpm/dist/rpm-4.1.x/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 ppc-macos s390 sh sparc x86"
IUSE="nls"

RDEPEND=""
DEPEND="nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	elibtoolize
	epatch "${FILESDIR}"/${P}-missing-tests.patch
	use nls || touch ../rpm.c
}

src_compile() {
	use ppc-macos && append-ldflags -undefined dynamic_lookup
	econf $(use_enable nls) || die
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc CHANGES README
}
