# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/ggobi/ggobi-2.1.8.ebuild,v 1.5 2010/04/05 20:04:46 hwoarang Exp $

EAPI=2
inherit eutils autotools

DESCRIPTION="Visualization program for exploring high-dimensional data"
HOMEPAGE="http://www.ggobi.org"
SRC_URI="http://www.ggobi.org/downloads/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal nls"

RDEPEND=">=media-gfx/graphviz-2.6
	>=x11-libs/gtk+-2.6
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	# build with external system libltdl
	rm -rf libltdl

	has_version ">=media-gfx/graphviz-2.22" && \
		epatch "${FILESDIR}"/${P}-graphviz.patch
	epatch "${FILESDIR}"/${P}-syslibltdl.patch
	epatch "${FILESDIR}"/${P}-plugindir.patch
	eautoreconf
}

src_configure() {
	econf \
		--disable-maintainer-mode \
		--disable-rpath \
		$(use_enable nls) \
		$(use_with !minimal all-plugins)
}

src_compile() {
	emake || die "emake failed"
	# generate default configuration
	emake ggobirc || die "ggobi configuration generation failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README AUTHORS NEWS ChangeLog
	insinto /etc/xdg/ggobi
	doins ggobirc || die
}
