# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/graphviz/graphviz-2.6-r1.ebuild,v 1.2 2006/04/04 19:24:33 flameeyes Exp $

inherit eutils libtool

DESCRIPTION="Open Source Graph Visualization Software"
HOMEPAGE="http://www.graphviz.org/"
SRC_URI="http://www.graphviz.org/pub/graphviz/ARCHIVE/${P}.tar.gz"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc-macos ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="cairo dynagraph tcltk X static"

RDEPEND=">=sys-libs/zlib-1.1.3
	 >=media-libs/libpng-1.2
	 >=media-libs/jpeg-6b
	 media-libs/freetype
	 media-libs/fontconfig
	 dev-libs/expat
	 sys-libs/zlib
	 tcltk? ( >=dev-lang/tk-8.3 )
	 cairo? ( >=x11-libs/libsvg-cairo-0.1.3 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}"-no-undefined.patch
	epatch "${FILESDIR}/${P}"-macos.patch

	elibtoolize
}

src_compile() {
	econf --with-mylibgd \
		--disable-dependency-tracking \
		$(use_enable static) \
		$(use_with dynagraph) \
		$(use_with tcltk tcl) $(use_with tcltk tk) \
		$(use_with X x) || die "Configure Failed!"
	emake || die "Compile Failed!"
}

src_install() {
	sed -i -e "s:htmldir:htmlinfodir:g" doc/info/Makefile
		make DESTDIR="${D}" \
		txtdir=/usr/share/doc/${PF} \
		htmldir=/usr/share/doc/${PF}/html \
		htmlinfodir=/usr/share/doc/${PF}/html/info \
		pdfdir=/usr/share/doc/${PF}/pdf \
		pkgconfigdir=/usr/$(get_libdir)/pkgconfig \
		install || die "Install Failed!"
}

pkg_postinst() {
	dot -c
}
