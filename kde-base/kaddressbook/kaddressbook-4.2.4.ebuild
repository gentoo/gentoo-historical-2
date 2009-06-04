# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kaddressbook/kaddressbook-4.2.4.ebuild,v 1.1 2009/06/04 11:11:36 alexxy Exp $

EAPI="2"

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="The KDE Address Book"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug +handbook gnokii"

DEPEND="
	>=kde-base/libkdepim-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/libkleo-${PV}:${SLOT}[kdeprefix=]
	gnokii? ( app-mobilephone/gnokii )
"
RDEPEND="${DEPEND}"

# xml targets from kmail are being uncommented by kde4-meta.eclass
KMEXTRACTONLY="
	kmail/
	libkleo/
"
KMLOADLIBS="libkdepim libkleo"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with gnokii GNOKII)"

	kde4-meta_src_configure
}

src_install() {
	kde4-meta_src_install

	# install additional generated header that is needed by kresources
	insinto "${KDEDIR}"/include/${PN}
	doins "${CMAKE_BUILD_DIR}"/${PN}/common/kabprefs_base.h || \
		die "Failed to install extra header files"
}
