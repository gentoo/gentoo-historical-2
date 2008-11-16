# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmailcvt/kmailcvt-4.1.3.ebuild,v 1.2 2008/11/16 07:43:43 vapier Exp $

EAPI="2"

KMNAME=kdepim
inherit kde4-meta

DESCRIPTION="KMail Import Filters"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug"

DEPEND="app-crypt/gnupg
	app-crypt/gpgme"
RDEPEND="${DEPEND}"

# xml targets from kmail are being uncommented by kde4-meta.eclass
KMEXTRACTONLY="kmail/"

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DWITH_QGpgme=ON"

	kde4-meta_src_configure
}
