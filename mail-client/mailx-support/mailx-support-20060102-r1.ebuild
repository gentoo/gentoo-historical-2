# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/mailx-support/mailx-support-20060102-r1.ebuild,v 1.12 2007/07/25 18:06:22 armin76 Exp $

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="Provides lockspool utility"
HOMEPAGE="http://www.openbsd.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-respect-ldflags.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" BINDNOW_FLAGS="$(bindnow-flags)" || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"
}
