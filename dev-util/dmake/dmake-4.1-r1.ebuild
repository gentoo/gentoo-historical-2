# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/dmake/dmake-4.1-r1.ebuild,v 1.22 2009/05/30 02:02:24 darkside Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Improved make"
SRC_URI="http://public.activestate.com/gsar/${P}pl1-src.tar.gz"
HOMEPAGE="http://tools.openoffice.org/dmake/"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"
IUSE=""

DEPEND="sys-apps/groff"
RDEPEND=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PF}.diff"
	sed -i "s/gcc/$(tc-getCC) ${CFLAGS}/g" unix/linux/gnu/make.sh || die "sed failed"
}

src_compile() {
	sh unix/linux/gnu/make.sh || die "sh unix/linux/gnu/make.sh failed"
}

src_install () {
	dobin dmake || die "dobin failed"
	newman man/dmake.tf dmake.1 || die "newman failed"

	insinto /usr/share/dmake/startup
	doins -r startup/{{startup,config}.mk,unix} || die "doins failed"
}
