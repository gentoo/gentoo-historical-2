# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/shash/shash-0.2.6-r1.ebuild,v 1.16 2006/09/29 15:26:50 dsd Exp $

inherit bash-completion eutils

DESCRIPTION="Generate or check digests or MACs of files"
HOMEPAGE="http://mcrypt.hellug.gr/shash/"
SRC_URI="ftp://mcrypt.hellug.gr/pub/mcrypt/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ~ppc-macos ppc64 s390 sh sparc x86"
IUSE="static"

DEPEND=">=app-crypt/mhash-0.8.18-r1"
# the following is required because bash-completion.eclass overwrites
# default RDEPEND, and this package depends on mhash at runtime
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/0.2.6-manpage-fixes.patch
}

src_compile() {
	econf $(use_enable static static-link) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die "install failed"
	dodoc AUTHORS ChangeLog INSTALL NEWS doc/sample.shashrc doc/FORMAT
	dobashcompletion "${FILESDIR}"/shash.bash-completion ${PN}
}
