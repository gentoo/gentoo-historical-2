# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/korganizer/korganizer-4.3.3.ebuild,v 1.1 2009/11/02 21:33:51 wired Exp $

EAPI="2"

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="A Personal Organizer for KDE"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug +handbook"

DEPEND="
	app-crypt/gpgme
	$(add_kdebase_dep libkdepim)
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep kaddressbook)
"

KMLOADLIBS="libkdepim"
KMEXTRA="kdgantt1"

# xml targets from kmail are being uncommented by kde4-meta.eclass
KMEXTRACTONLY="
	kaddressbook/org.kde.KAddressbook.Core.xml
	kmail/
	knode/org.kde.knode.xml
"

src_unpack() {
	if use kontact; then
		KMLOADLIBS="${KMLOADLIBS} kontactinterfaces"
		KMEXTRA="${KMEXTRA} kontact/plugins/planner"
	fi

	kde4-meta_src_unpack
}

src_prepare() {
	if use kontact; then
		# Fix target_link_libraries for now
		sed -i -e's/kaddressbookprivate//' \
			kontact/plugins/planner/CMakeLists.txt \
			|| die "Failed to remove kaddressbookprivate from link"
	fi

	kde4-meta_src_prepare
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	if ! has_version kde-base/kdepim-kresources:${SLOT}; then
		echo
		elog "For groupware functionality, please install kde-base/kdepim-kresources:${SLOT}"
		echo
	fi
}
