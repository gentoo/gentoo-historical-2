# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/lensfun/lensfun-0.2.3.ebuild,v 1.6 2009/09/19 11:58:17 maekke Exp $

inherit eutils

DESCRIPTION="lensfun: A library for rectifying and simulating photographic lens
distortions"
HOMEPAGE="http://lensfun.berlios.de/"
SRC_URI="mirror://berlios/lensfun/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc64 ~x86"
IUSE="doc"

RDEPEND="
	>=dev-libs/glib-2.0
	>=media-libs/libpng-1.0"
DEPEND="${RDEPEND}
	doc? ( >=app-doc/doxygen-1.5.0 )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-as-needed.patch
	epatch "${FILESDIR}"/${P}-glibc-2.10.patch

	# disable stripping
	sed -i -e 's:GCC.LDFLAGS.release = -s:GCC.LDFLAGS.release =:g' \
		build/mak/compiler/gcc.mak
}

src_compile() {
	# econf does NOT work
	./configure --prefix=/usr || die
	emake all V=1 || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	# TODO remove docs if ! use doc
}
