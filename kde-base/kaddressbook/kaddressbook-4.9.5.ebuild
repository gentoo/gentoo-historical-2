# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kaddressbook/kaddressbook-4.9.5.ebuild,v 1.3 2013/01/27 15:04:29 ago Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="The KDE Address Book"
KEYWORDS="amd64 ~arm ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	>=dev-libs/grantlee-0.2.0
	$(add_kdebase_dep kdelibs 'semantic-desktop')
	$(add_kdebase_dep kdepimlibs 'semantic-desktop')
	$(add_kdebase_dep kdepim-common-libs)
"
RDEPEND="${DEPEND}"

KMEXTRA="
	plugins/kaddressbook/
	plugins/ktexteditor/
"
KMEXTRACTONLY="
	akonadi_next/
	calendarsupport/
	libkleo/
"

KMLOADLIBS="kdepim-common-libs"

pkg_postinst() {
	kde4-meta_pkg_postinst

	if ! has_version kde-base/kdepim-kresources:${SLOT}; then
		echo
		elog "For groupware functionality, please install kde-base/kdepim-kresources:${SLOT}"
		echo
	fi
}
