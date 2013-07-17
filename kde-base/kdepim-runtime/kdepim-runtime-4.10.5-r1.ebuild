# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim-runtime/kdepim-runtime-4.10.5-r1.ebuild,v 1.2 2013/07/17 04:41:48 patrick Exp $

EAPI=5

KMNAME="kdepim-runtime"
inherit kde4-base

DESCRIPTION="KDE PIM runtime plugin collection"
KEYWORDS=" ~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug google kolab"

RESTRICT="test"
# Would need test programs _testrunner and akonaditest from kdepimlibs, see bug 313233

DEPEND="
	app-misc/strigi
	>=app-office/akonadi-server-1.9.0
	dev-libs/boost:=
	dev-libs/libxml2:2
	dev-libs/libxslt
	>=dev-libs/shared-desktop-ontologies-0.10.0
	|| ( <dev-qt/qtgui-4.8.5:4 ( >=dev-qt/qtgui-4.8.5:4 dev-qt/designer ) )
	$(add_kdebase_dep kdepimlibs 'semantic-desktop(+)')
	x11-misc/shared-mime-info
	google? ( >=net-libs/libkgapi-0.4.3 )
	kolab? ( net-libs/libkolab )
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep kdepim-icons)
	!kde-misc/akonadi-google
"

# nepomuk_email_feeder moved here in 4.8
add_blocker kdepim-common-libs 4.7.50

src_configure() {
	epatch "${FILESDIR}/${PN}-4.10.5-fix-autoconfig.patch"
	local mycmakeargs=(
		$(cmake-utils_use_find_package google LibKGAPI)
		$(cmake-utils_use_find_package kolab Libkolab)
		$(cmake-utils_use_find_package kolab Libkolabxml)
	)

	kde4-base_src_configure
}
