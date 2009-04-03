# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libassuan/libassuan-1.0.5.ebuild,v 1.5 2009/04/03 20:56:08 tcunha Exp $

inherit flag-o-matic eutils

DESCRIPTION="Standalone IPC library used by gpg, gpgme and newpg"
HOMEPAGE="http://www.gnupg.org/related_software/libassuan.en.html"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-libs/pth-1.3.7
	>=dev-libs/libgpg-error-1.4"
RDEPEND="${DEPEND}"

src_unpack()
{
	unpack ${A}
	epatch "${FILESDIR}"/libassuan-1.0.5-qa.patch
}

src_compile() {
	# https://bugs.g10code.com/gnupg/issue817
	append-flags "-fpic -fPIC"
	append-ldflags "-fpic -fPIC"

	econf || die
	emake || die
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}
