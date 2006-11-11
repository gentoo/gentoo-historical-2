# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ogmrip/ogmrip-0.10.0-r1.ebuild,v 1.3 2006/11/11 22:07:12 vivo Exp $

inherit gnome2 eutils autotools

DESCRIPTION="Graphical frontend and libraries for ripping DVDs and encoding to AVI/OGM/MKV/MP4"
HOMEPAGE="http://ogmrip.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/${PN}-0.10.0-mplayer-rc.patch"
LICENSE="LGPL-2.1"

SLOT="0"
IUSE="aac debug doc gtk hal matroska spell srt theora"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND=">=dev-libs/glib-2.6
	>=dev-libs/libxml2-2
	>=media-libs/libdvdread-0.9.4
	>=media-sound/lame-3.96
	>=media-sound/ogmtools-1.4
	>=media-sound/vorbis-tools-1.0
	>=media-video/mplayer-1.0_pre4
	aac? ( >=media-libs/faac-1.24 )
	gtk? ( >=x11-libs/gtk+-2.6
		>=gnome-base/gconf-2.6
		>=gnome-base/libglade-2.5 )
	hal? ( >=sys-apps/hal-0.4.2 )
	matroska? ( >=media-video/mkvtoolnix-0.9 )
	spell? ( >=app-text/enchant-1.1 )
	srt? ( >=app-text/gocr-0.39 )
	theora? ( >=media-libs/libtheora-1.0_alpha6 )"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.29
	>=dev-util/pkgconfig-0.12.0"

G2CONF="${G2CONF}
	$(use_enable aac aac-support)
	$(use_enable debug maintainer-mode)
	$(use_enable gtk gtk-support)
	$(use_enable hal hal-support)
	$(use_enable matroska matroska-support)
	$(use_enable spell enchant-support)
	$(use_enable srt srt-support)
	$(use_enable theora theora-support)"

DOCS="AUTHORS ChangeLog README NEWS TODO"

pkg_setup() {
	if ! built_with_use -a media-video/mplayer dvd encode xvid; then
		eerror "Please, check that your USE flags contain 'dvd', 'encode' and"
		eerror "'xvid' and emerge mplayer again."
		die "MPlayer is not built with dvd, encoding or xvid support."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${DISTDIR}/${P}-mplayer-rc.patch"
	eautoreconf
}
