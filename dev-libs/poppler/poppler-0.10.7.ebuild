# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/poppler/poppler-0.10.7.ebuild,v 1.4 2009/06/11 21:36:33 maekke Exp $

EAPI=2

POPPLER_MODULE=poppler

inherit poppler

DESCRIPTION="PDF rendering library based on the xpdf-3.0 code base"
HOMEPAGE="http://poppler.freedesktop.org/"
SRC_URI="http://poppler.freedesktop.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE="+abiword +poppler-data"

DEPEND="
	abiword? ( >=dev-libs/libxml2-2.7.2 )
	>=media-libs/freetype-2.3.7
	>=media-libs/fontconfig-2
	>=media-libs/jpeg-6b
	>=media-libs/openjpeg-1.3-r2
	sys-libs/zlib
	"
RDEPEND="
	${DEPEND}
	poppler-data? ( >=app-text/poppler-data-0.2.1 )
	!<dev-libs/poppler-qt3-${PV}
	!<dev-libs/poppler-qt4-${PV}
	!<dev-libs/poppler-glib-${PV}
	!<app-text/poppler-utils-${PV}
	"

pkg_setup() {
	POPPLER_CONF="$(use_enable abiword abiword-output) --disable-poppler-qt4 --disable-cairo-output"
	POPPLER_PKGCONFIG=( "poppler-splash.pc" "poppler.pc" )
}

src_compile() {
	for dir in goo fofi splash poppler
	do
		POPPLER_MODULE_S="${S}/${dir}" poppler_src_compile
	done
}

src_install() {
	for dir in goo fofi splash poppler
	do
		POPPLER_MODULE_S="${S}/${dir}" poppler_src_install
	done
}
