# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepimlibs/kdepimlibs-4.2.4.ebuild,v 1.1 2009/06/04 12:06:52 alexxy Exp $

EAPI="2"

CPPUNIT_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="Common library for KDE PIM apps."
HOMEPAGE="http://www.kde.org/"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
LICENSE="LGPL-2.1"
IUSE="debug +handbook ldap +sasl"

# some akonadi tests timeout, that probaly needs more work as its ~700 tests
RESTRICT="test"

DEPEND="
	>=app-crypt/gpgme-1.1.6
	>=app-office/akonadi-server-1.1
	dev-libs/boost
	dev-libs/libgpg-error
	>=dev-libs/libical-0.33-r1
	ldap? ( net-nds/openldap )
	sasl? ( dev-libs/cyrus-sasl )
"
RDEPEND="${DEPEND}
	!kdeprefix? ( !kde-base/akonadi:4.1 )
"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_build handbook doc)
		$(cmake-utils_use_with ldap Ldap)
		$(cmake-utils_use_with sasl Sasl2)"

	kde4-base_src_configure
}
