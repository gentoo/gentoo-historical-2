# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/fung-calc/fung-calc-1.3.2b.ebuild,v 1.9 2004/10/27 21:13:43 motaboy Exp $

inherit kde eutils flag-o-matic

IUSE="opengl"

DESCRIPTION="Scientific Graphing Calculator"
HOMEPAGE="http://fung-calc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"

DEPEND=">=sys-libs/zlib-1
	>=media-libs/libpng-1.2
	>=media-libs/jpeg-6
	virtual/libc
	opengl? ( virtual/opengl )
	>=kde-base/kdebase-3.1"

need-kde 3.1
need-qt 3.1

src_unpack() {
	kde_src_unpack

	epatch ${FILESDIR}/fung-calc-fPIC
	epatch ${FILESDIR}/fung-calc-gcc34-fix
	useq arts || epatch ${FILESDIR}/fung-calc-1.3.2b-configure.patch
}

src_compile() {
	kde_src_compile myconf

	use opengl || myconf="${myconf} --disable-glgraph"
	# use kde || myconf="${myconf} --disable-kde-app"

	kde_src_compile configure make
}
