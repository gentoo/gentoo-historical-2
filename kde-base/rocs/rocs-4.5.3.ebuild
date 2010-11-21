# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/rocs/rocs-4.5.3.ebuild,v 1.3 2010/11/21 22:05:15 dilfridge Exp $

EAPI="3"

KDE_HANDBOOK="optional"
KMNAME="kdeedu"
inherit kde4-meta

DESCRIPTION="KDE4 interface to work with Graph Theory"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	>=dev-cpp/eigen-2.0.3:2
"
RDEPEND=""

PATCHES=( "${FILESDIR}/${P}-double.patch" )

src_prepare() {
	kde4-meta_src_prepare
	use handbook && epatch "${FILESDIR}/${P}-double-handbook.patch"
}
