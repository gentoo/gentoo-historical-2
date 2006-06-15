# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/kmplayer/kmplayer-0.9.2a.ebuild,v 1.2 2006/06/15 09:40:02 carlo Exp $

inherit kde

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="KMPlayer is a Video player plugin for Konqueror and basic MPlayer/Xine/ffmpeg/ffserver/VDR frontend for KDE."
HOMEPAGE="http://kmplayer.kde.org/"
SRC_URI="http://kmplayer.kde.org/pkgs/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gstreamer mplayer xine"

DEPEND="xine? ( >=media-libs/xine-lib-1.1.1 )
	gstreamer? ( || ( =media-libs/gst-plugins-base-0.10* =media-libs/gst-plugins-0.8* ) )"

RDEPEND="mplayer? ( media-video/mplayer )
	xine? ( >=media-libs/xine-lib-1.1.1 )
	gstreamer? ( || ( =media-libs/gst-plugins-base-0.10*	=media-libs/gst-plugins-0.8* ) )"

need-kde 3

pkg_setup() {
	if ! use mplayer && ! use xine ; then
		echo
		ewarn "Neither mplayer nor xine use flag is set. Either one is needed."
		ewarn "You can install mplayer later, though.\n"
	fi
}

src_compile(){
	local myconf="$(use_with gstreamer) $(use_with xine)"
	kde_src_compile
}
