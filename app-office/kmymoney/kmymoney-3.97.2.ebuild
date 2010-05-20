# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/kmymoney/kmymoney-3.97.2.ebuild,v 1.2 2010/05/20 13:59:50 ssuominen Exp $

EAPI=2
KDE_LINGUAS="bg ca ca@valencia cs da de el en_GB eo es et fi fr ga gl hu it lt
ms nds nl pl pt pt_BR ro ru sk sv tr uk zh_CN zh_TW"
KDE_DOC_DIRS="doc doc-translations/%lingua_${PN}"
inherit kde4-base

DESCRIPTION="A personal finance manager for KDE"
HOMEPAGE="http://sourceforge.net/projects/kmymoney2/"
SRC_URI="mirror://sourceforge/kmymoney2/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug calendar +handbook hbci ofx quotes test"

COMMON_DEPEND="app-crypt/gpgme
	>=dev-libs/boost-1.33.1
	dev-libs/libxml2
	dev-libs/libgpg-error
	>=kde-base/kdepimlibs-${KDE_MINIMAL}
	calendar? ( dev-libs/libical )
	hbci? ( >=net-libs/aqbanking-4.2.4[qt4]
		>=sys-libs/gwenhywfar-3.11.3 )
	ofx? ( >=dev-libs/libofx-0.9.1 )"
RDEPEND="${COMMON_DEPEND}
	quotes? ( >=dev-perl/Finance-Quote-1.17 )"
DEPEND="${COMMON_DEPEND}
	test? ( >=dev-util/cppunit-1.12.1 )"

DOCS="AUTHORS BUGS ChangeLog* README* TODO"

RESTRICT="test"

src_configure() {
	mycmakeargs+=(
		$(cmake-utils_use_enable hbci KBANKING)
		$(cmake-utils_use_enable calendar LIBICAL)
		$(cmake-utils_use_enable ofx LIBOFX)
		$(cmake-utils_use test KDE4_BUILD_TESTS)
		)

	kde4-base_src_configure
}
