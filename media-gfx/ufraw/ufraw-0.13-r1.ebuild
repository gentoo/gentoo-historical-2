# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/ufraw/ufraw-0.13-r1.ebuild,v 1.4 2008/10/19 15:02:22 maekke Exp $

inherit eutils autotools fdo-mime gnome2-utils

DESCRIPTION="RAW Image format viewer and GIMP plugin"
HOMEPAGE="http://ufraw.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86 ~x86-fbsd"
IUSE="exif gimp gnome"

RDEPEND="media-libs/jpeg
	>=media-libs/lcms-1.13
	media-libs/tiff
	>=x11-libs/gtk+-2.4.0
	exif? ( >=media-libs/libexif-0.6.13
	        media-gfx/exiv2 )
	gimp? ( >=media-gfx/gimp-2.0 )
	gnome? ( gnome-base/gconf )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-cflags.patch
	epatch "${FILESDIR}"/${P}-Canon450D.patch
	eautoreconf || die "failed running autoreconf"
}

src_compile() {
	econf $(use_enable gnome mime) || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README TODO || die "doc installation failed"
}

pkg_postinst() {
	if use gnome ; then
		fdo-mime_mime_database_update
		gnome2_gconf_install
		fdo-mime_desktop_database_update
	fi
}
