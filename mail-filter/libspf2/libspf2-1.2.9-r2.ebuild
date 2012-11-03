# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/libspf2/libspf2-1.2.9-r2.ebuild,v 1.1 2012/11/03 07:24:03 eras Exp $

EAPI=4
inherit eutils

DESCRIPTION="libspf2 implements the Sender Policy Framework, a part of the SPF/SRS protocol pair."
HOMEPAGE="http://www.libspf2.org"
SRC_URI="http://www.libspf2.org/spf/libspf2-${PV}.tar.gz"

LICENSE="|| ( LGPL-2.1 BSD-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="static-libs"

DEPEND=""
RDEPEND="!dev-perl/Mail-SPF-Query"

src_install() {
	emake DESTDIR="${D}" install
	dodoc README TODO INSTALL

	use static-libs || rm -f "${D}"/usr/lib*/libspf2.la \
		"${D}"/usr/lib*/libspf2.a
}
