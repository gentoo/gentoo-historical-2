# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepimlibs/kdepimlibs-4.3.0.ebuild,v 1.1 2009/08/04 00:20:51 wired Exp $

EAPI="2"

CPPUNIT_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="Common library for KDE PIM apps."
HOMEPAGE="http://www.kde.org/"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
LICENSE="LGPL-2.1"
IUSE="debug +handbook ldap"

# some akonadi tests timeout, that probaly needs more work as its ~700 tests
RESTRICT="test"

DEPEND="
	>=app-crypt/gpgme-1.1.6
	>=app-office/akonadi-server-1.2.0
	dev-libs/boost
	dev-libs/libgpg-error
	>=dev-libs/libical-0.42
	dev-libs/cyrus-sasl
	ldap? ( net-nds/openldap )
"
# @since 4.3 - libkholidays is in kdepimlibs now
RDEPEND="${DEPEND}
	!kdeprefix? (
		!kde-base/akonadi:4.1
		!kde-base/libkholidays:4.1
		!kde-base/libkholidays:4.2
	)
"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_build handbook doc)
		$(cmake-utils_use_with ldap)"

	kde4-base_src_configure
}
