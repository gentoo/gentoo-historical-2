# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/iso-codes/iso-codes-0.49.ebuild,v 1.14 2006/11/09 22:27:27 allanonjl Exp $

WANT_AUTOMAKE="latest"
WANT_AUTOCONF="latest"
inherit autotools

DESCRIPTION="Provides the list of country and language names"
HOMEPAGE="http://alioth.debian.org/projects/pkg-isocodes/"
SRC_URI="mirror://debian/pool/main/i/iso-codes/${PN}_${PV}.orig.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86"
IUSE=""

DEPEND="sys-devel/gettext
		>=dev-lang/python-2.3
		>=dev-python/pyxml-0.8.4
		>=sys-devel/automake-1.9"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	sed -i -e 's:(datadir)/pkgconfig:(libdir)/pkgconfig:g' Makefile.am
	eaclocal
	eautoconf
	eautomake
}

src_compile() {
	econf || die "configure failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc ChangeLog README TODO
}
