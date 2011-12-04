# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksysguard/ksysguard-4.7.3.ebuild,v 1.2 2011/12/04 16:06:38 dilfridge Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kde-workspace"
CPPUNIT_REQUIRED="optional"
VIRTUALX_REQUIRED=test
inherit kde4-meta

DESCRIPTION="KSysguard is a network enabled task manager and system monitor application."
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug lm_sensors test"

COMMONDEPEND="
	x11-libs/libXrender
	x11-libs/libXres
	lm_sensors? ( sys-apps/lm_sensors )
"
DEPEND="${COMMONDEPEND}
	x11-proto/renderproto
"
RDEPEND="${COMMONDEPEND}"

RESTRICT="test"
# bug 393091

KMEXTRA="
	libs/ksysguard/
"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with lm_sensors Sensors)
	)

	kde4-meta_src_configure
}

pkg_postinst() {
	kde4-meta_pkg_postinst
	ewarn "Note that ksysguard has powerful features; one of these is the executing of arbitrary"
	ewarn "programs with elevated privileges (as data sources). So be careful opening worksheets"
	ewarn "from untrusted sources!"
}
