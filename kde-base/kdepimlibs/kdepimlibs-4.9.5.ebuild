# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepimlibs/kdepimlibs-4.9.5.ebuild,v 1.3 2013/01/27 15:23:47 ago Exp $

EAPI=4

KDE_HANDBOOK="optional"
CPPUNIT_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="Common library for KDE PIM apps."
KEYWORDS="amd64 ~arm ~ppc x86 ~amd64-linux ~x86-linux"
LICENSE="LGPL-2.1"
IUSE="debug ldap prison semantic-desktop"

# some akonadi tests timeout, that probaly needs more work as its ~700 tests
RESTRICT="test"

DEPEND="
	>=app-crypt/gpgme-1.1.6
	>=dev-libs/boost-1.35.0-r5
	dev-libs/libgpg-error
	>=dev-libs/libical-0.43
	dev-libs/cyrus-sasl
	$(add_kdebase_dep kdelibs 'semantic-desktop=')
	prison? ( media-libs/prison )
	semantic-desktop? (
		>=app-office/akonadi-server-1.8.1
		media-libs/phonon
		x11-misc/shared-mime-info
	)
	ldap? ( net-nds/openldap )
"
# boost is not linked to, but headers which include it are installed
# bug #418071
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-4.9.1-boostincludes.patch" )

src_prepare() {
	kde4-base_src_prepare

	# Disable hardcoded checks
	sed -r -e '/find_package\((Akonadi|SharedDesktopOntologies|Soprano|Nepomuk)/{/macro_optional_/!s/find/macro_optional_&/}' \
		-e '/macro_log_feature\((Akonadi|SHAREDDESKTOPONTOLOGIES|Soprano|Nepomuk)_FOUND/s/ TRUE / FALSE /' \
		-e '/add_subdirectory\((akonadi|mailtransport)/{/macro_optional_/!s/add/macro_optional_&/}' \
		-i CMakeLists.txt || die
	if ! use semantic-desktop; then
		sed -e '/include(SopranoAddOntology)/s/^/#DISABLED /' \
			-i CMakeLists.txt || die
		# More reliable than -DBUILD_akonadi=OFF
		rm -r akonadi mailtransport || die
	fi
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_build handbook doc)
		$(cmake-utils_use_with ldap)
		$(cmake-utils_use_with semantic-desktop Akonadi)
		$(cmake-utils_use_with semantic-desktop SharedDesktopOntologies)
		$(cmake-utils_use_with semantic-desktop Soprano)
		$(cmake-utils_use_with semantic-desktop Nepomuk)
		$(cmake-utils_use !semantic-desktop KALARM_USE_KRESOURCES)
		$(cmake-utils_use_with prison)
	)

	kde4-base_src_configure
}
