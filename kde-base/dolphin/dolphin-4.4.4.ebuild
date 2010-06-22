# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/dolphin/dolphin-4.4.4.ebuild,v 1.3 2010/06/22 18:53:46 arfrever Exp $

EAPI="3"

KMNAME="kdebase-apps"
inherit kde4-meta

DESCRIPTION="A KDE filemanager focusing on usability"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +handbook semantic-desktop subversion thumbnail"

DEPEND="
	$(add_kdebase_dep kdelibs 'semantic-desktop?')
	$(add_kdebase_dep libkonq)
	semantic-desktop? ( >=dev-libs/shared-desktop-ontologies-0.2 )
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep kfind)
	subversion? (
		dev-vcs/subversion
		$(add_kdebase_dep kompare)
	)
"
PDEPEND="
	thumbnail? ( $(add_kdebase_dep mplayerthumbs) )
"

KMLOADLIBS="libkonq"

src_prepare() {
	kde4-meta_src_prepare

	if ! use subversion; then
		sed -e '/install(.*fileviewsvnplugin.*)/s/^/#DONOTINSTALL /g' \
			-i dolphin/src/CMakeLists.txt || die 'failed to disable subversion plugin'
	fi
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with semantic-desktop Nepomuk)
	)

	kde4-meta_src_configure
}
