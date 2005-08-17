# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgpg-error/libgpg-error-1.0-r1.ebuild,v 1.13 2005/08/17 22:41:00 matsuu Exp $

inherit libtool eutils

DESCRIPTION="Contains error handling functions used by GnuPG software"
HOMEPAGE="http://www.gnupg.org/(en)/download/index.html#libgpg-error"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 ppc-macos s390 sh sparc x86"
IUSE="nls"

DEPEND="!ppc-macos? ( >=sys-devel/autoconf-2.59 )"

RDEPEND="nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/libgpg-error-1.0-locale.h.patch
	if ! use ppc-macos ; then
		env WANT_AUTOCONF=2.59 autoconf || die "autoconf failed"
		autoheader || die "autoheader failed"
	fi
	uclibctoolize
}

src_compile() {
	econf $(use_enable nls) || die
	emake || die
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README
}
