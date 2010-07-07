# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/gnome-subtitles/gnome-subtitles-0.9.1.ebuild,v 1.2 2010/07/07 09:11:04 hwoarang Exp $

EAPI=2

inherit mono gnome2 eutils autotools

DESCRIPTION="Video subtitling for the Gnome desktop"
HOMEPAGE="http://gnome-subtitles.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnome-subtitles/${P}.tar.gz"
LICENSE="GPL-2"
IUSE=""
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
RDEPEND=">=dev-lang/mono-1.1
	>=dev-dotnet/glade-sharp-2.12
	>=dev-dotnet/gtk-sharp-2.12
	>=dev-dotnet/gconf-sharp-2.12
	>=media-libs/gstreamer-0.10
	>=app-text/gtkspell-2.0
	>=app-text/enchant-1.3
	>=media-libs/gst-plugins-base-0.10"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	dev-util/pkgconfig
	app-text/gnome-doc-utils"

src_prepare() {
	epatch "${FILESDIR}/${P}-as-needed.patch"
	eautoreconf
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	find "${D}" -name '*.la' -exec rm -rf '{}' '+' || die "la removal failed"
}

DOCS="AUTHORS ChangeLog NEWS README"
