# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/iso-codes/iso-codes-3.10.ebuild,v 1.4 2009/11/08 20:14:59 nixnut Exp $

EAPI="2"

DESCRIPTION="Provides the list of country and language names"
HOMEPAGE="http://alioth.debian.org/projects/pkg-isocodes/"
SRC_URI="ftp://pkg-isocodes.alioth.debian.org/pub/pkg-isocodes/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ~ia64 ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="sys-devel/gettext
	|| (
		>=dev-lang/python-2.3[-build,xml]
		dev-python/pyxml )"

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"

	dodoc ChangeLog README TODO
}
