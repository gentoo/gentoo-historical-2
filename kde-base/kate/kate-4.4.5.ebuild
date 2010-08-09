# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kate/kate-4.4.5.ebuild,v 1.3 2010/08/09 02:54:15 josejx Exp $

EAPI="3"

KMNAME="kdesdk"
inherit kde4-meta

DESCRIPTION="Kate is an MDI texteditor."
KEYWORDS="~alpha amd64 ~ia64 ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +handbook +plasma"

DEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with plasma)
	)

	kde4-meta_src_configure
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	if ! has_version kde-base/kaddressbook:${SLOT}; then
		echo
		elog "File templates plugin requires kde-base/kaddressbook:${SLOT}."
		elog "Please install it if you plan to use this plugin."
		echo
	fi
}
