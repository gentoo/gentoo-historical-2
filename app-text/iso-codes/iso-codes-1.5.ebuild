# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/iso-codes/iso-codes-1.5.ebuild,v 1.7 2007/11/29 05:32:10 jer Exp $

WANT_AUTOMAKE="latest"
inherit eutils autotools

DESCRIPTION="Provides the list of country and language names"
HOMEPAGE="http://alioth.debian.org/projects/pkg-isocodes/"
SRC_URI="ftp://pkg-isocodes.alioth.debian.org/pub/pkg-isocodes/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="sys-devel/gettext
	>=dev-lang/python-2.3
	>=sys-devel/automake-1.9"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# fix install location for multilib machines
	sed -i -e 's:(datadir)/pkgconfig:(libdir)/pkgconfig:g' Makefile.am

	eautomake
}

src_compile() {
	econf || die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"

	dodoc ChangeLog README TODO
}
