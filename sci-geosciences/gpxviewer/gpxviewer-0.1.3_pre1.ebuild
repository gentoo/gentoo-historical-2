# Copyrieht 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/gpxviewer/gpxviewer-0.1.3_pre1.ebuild,v 1.1 2010/06/18 10:14:17 jlec Exp $

EAPI="2"

inherit autotools eutils

MY_PN="gpx-viewer"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="GPX Viewer is a simple program to visualize a gpx file"
HOMEPAGE="http://blog.sarine.nl/${PN}/"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	>=dev-lang/vala-0.7
	dev-libs/gdl
	dev-libs/glib:2
	dev-libs/libxml2
	media-libs/libchamplain:0.6[gtk]
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.21
	dev-util/pkgconfig"

S="${WORKDIR}"/${MY_PN}

src_prepare() {
	epatch "${FILESDIR}/${PV}-configure.ac.patch"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls)
}

src_compile() {
	emake gpx_viewer_vala.stamp || die
	emake || die
}

src_install () {
	emake DESTDIR="${D}" install || die "install failed"
	dosym ../icons/hicolor/scalable/apps/gpx-viewer.svg /usr/share/pixmaps/gpx-viewer.svg || die
	dodoc AUTHORS README ChangeLog || die "dodoc failed"
}
