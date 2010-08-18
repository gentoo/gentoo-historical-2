# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/kmymoney/kmymoney-4.5.ebuild,v 1.1 2010/08/18 21:29:48 reavertm Exp $

EAPI=2

KDE_LINGUAS="bg ca ca@valencia cs da de el en_GB eo es et fi fr ga gl hu it lt
ms nds nl pl pt pt_BR ro ru sk sv tr uk zh_CN zh_TW"
KDE_DOC_DIRS="doc doc-translations/%lingua_${PN}"
inherit virtualx kde4-base

DESCRIPTION="A personal finance manager for KDE"
HOMEPAGE="http://kmymoney2.sourceforge.net/"
SRC_URI="mirror://sourceforge/kmymoney2/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug calendar doc +handbook hbci ofx quotes test"

COMMON_DEPEND="
	app-crypt/gpgme
	>=dev-libs/boost-1.33.1
	dev-libs/libgpg-error
	dev-libs/libxml2
	>=kde-base/kdepimlibs-${KDE_MINIMAL}
	calendar? ( dev-libs/libical )
	hbci? (
		>=net-libs/aqbanking-4.2.4[qt4]
		>=sys-libs/gwenhywfar-3.11.3
	)
	ofx? ( >=dev-libs/libofx-0.9.1 )
"
RDEPEND="${COMMON_DEPEND}
	quotes? ( >=dev-perl/Finance-Quote-1.17 )
"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
	test? ( >=dev-util/cppunit-1.12.1 )
"

src_configure() {
	mycmakeargs=(
		-DUSE_QT_DESIGNER=OFF
		$(cmake-utils_use_enable calendar LIBICAL)
		$(cmake-utils_use_use doc DEVELOPER_DOC)
		$(cmake-utils_use_enable hbci KBANKING)
		$(cmake-utils_use_enable ofx LIBOFX)
		$(cmake-utils_use test KDE4_BUILD_TESTS)
	)
	kde4-base_src_configure
}

src_compile() {
	kde4-base_src_compile
	use doc && kde4-base_src_compile apidoc
}

src_install() {
	use doc && HTML_DOCS=("${CMAKE_BUILD_DIR}/apidocs/html/")
	kde4-base_src_install
}

src_test() {
	export maketype="kde4-base_src_test"
	virtualmake
}
