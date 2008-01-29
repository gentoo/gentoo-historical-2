# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/swfdec/swfdec-0.5.4-r1.ebuild,v 1.2 2008/01/29 20:50:49 drac Exp $

EAPI=1

inherit eutils versionator confutils

MY_PV=$(get_version_component_range 1-2)
DESCRIPTION="Macromedia Flash decoding library"
HOMEPAGE="http://swfdec.freedesktop.org"
SRC_URI="http://swfdec.freedesktop.org/download/${PN}/${MY_PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="ffmpeg gstreamer gnome mad oss alsa pulseaudio soup"

RESTRICT="test"

RDEPEND=">=dev-libs/glib-2.12
	>=dev-libs/liboil-0.3.1
	>=x11-libs/pango-1.16.4
	soup? ( net-libs/libsoup:2.2 )
	>=x11-libs/cairo-1.2
	>=x11-libs/gtk+-2.8.0
	>=media-libs/alsa-lib-1.0.12
	ffmpeg? ( >=media-video/ffmpeg-0.4.9_p20070330 )
	mad? ( >=media-libs/libmad-0.15.1b )
	gstreamer? ( >=media-libs/gstreamer-0.10.11 )
	gnome? ( gnome-base/gnome-vfs )
	alsa? ( >=media-libs/alsa-lib-1.0 )
	pulseaudio? ( media-sound/pulseaudio )
	!<=net-www/swfdec-mozilla-0.5.2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	if use ppc && use ffmpeg ; then
		eerror "swfdec doesn't work with latest ffmpeg version in"
		eerror "ppc arch. See bug #11841 in Freedesktop Bugzilla."
		eerror "Please disable ffmpeg flag and enable gstreamer"
		die "Depends failed"
	fi
	if use !gnome ; then
		ewarn "In order to compile libswfdec-gtk with Gnome-VFS"
		ewarn "support you must have 'gnome' USE flag enabled"
	fi
	if use !soup ; then
		ewarn "swfdec will be built without HTTP protocol support"
		ewarn "so you won't be able to use swfdec-mozilla, please"
		ewarn "add 'soup' to your USE flags"
	fi
	confutils_use_conflict oss alsa pulseaudio
}

src_compile() {
	local myconf
	local myaudio

	#--with-audio=[auto/alsa/oss/none]
	myaudio="none"
	use oss && myaudio="oss"
	use pulseaudio && myaudio="pa"
	use alsa && myaudio="alsa"
	myconf=" --with-audio=$myaudio"

	econf \
		$(use_enable gstreamer) \
		$(use_enable ffmpeg) \
		$(use_enable mad) \
		$(use_enable gnome gnome-vfs) \
		$(use_enable soup) \
		${myconf} || die "configure failed"

	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog README
}
