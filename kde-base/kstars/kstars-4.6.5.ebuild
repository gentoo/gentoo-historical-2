# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kstars/kstars-4.6.5.ebuild,v 1.3 2011/08/15 22:04:37 maekke Exp $

EAPI=4

KDE_HANDBOOK="optional"
KDE_SCM="git"
if [[ ${PV} == *9999 ]]; then
	kde_eclass="kde4-base"
else
	KMNAME="kdeedu"
	kde_eclass="kde4-meta"
fi
inherit ${kde_eclass}

DESCRIPTION="KDE Desktop Planetarium"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug fits indi"

DEPEND="
	dev-cpp/eigen:2
	$(add_kdebase_dep libkdeedu)
	fits? ( >=sci-libs/cfitsio-0.390 )
	indi? ( >=sci-libs/indilib-0.6.2[fits?] )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.4.65-solaris.patch
)

src_configure() {
	# Bug 308903
	use ppc64 && append-flags -mminimal-toc

	mycmakeargs=(
		$(cmake-utils_use_with fits CFitsio)
		$(cmake-utils_use_with indi)
	)

	${kde_eclass}_src_configure
}
