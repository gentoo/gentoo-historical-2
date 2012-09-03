# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kajongg/kajongg-4.8.5.ebuild,v 1.4 2012/09/03 12:20:14 scarabeus Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdegames"
PYTHON_DEPEND="2:2.6"
inherit kde4-meta python

DESCRIPTION="The classical Mah Jongg for four players"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	dev-db/sqlite:3
	$(add_kdebase_dep libkdegames)
	$(add_kdebase_dep pykde4)
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep libkmahjongg)
	>=dev-python/twisted-8.2.0
"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
	kde4-meta_pkg_setup
}

src_prepare() {
	python_convert_shebangs -r 2 kajongg/src
	kde4-meta_src_prepare
}
