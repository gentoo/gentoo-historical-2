# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/beep-media-player/beep-media-player-0.9.6.1.ebuild,v 1.2 2004/02/07 19:22:25 vapier Exp $

inherit eutils

MY_PN="bmp"
MY_P=bmp-${PV}

DESCRIPTION="Beep Media Player"
HOMEPAGE="http://beepmp.sourceforge.net/"
SRC_URI="mirror://sourceforge/beepmp/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~amd64"
IUSE="nls esd gnome opengl oggvorbis mikmod alsa"

RDEPEND="app-arch/unzip
	>=x11-libs/gtk+-2.2
	>=x11-libs/pango-1.2
	>=dev-libs/libxml-1.8.15
	mikmod? ( >=media-libs/libmikmod-3.1.10 )
	esd? ( >=media-sound/esound-0.2.29 )
	gnome? ( >=gnome-base/gnome-2.2 )
	opengl? ( virtual/opengl )
	oggvorbis? ( >=media-libs/libvorbis-1.0 )
	alsa? ( >=media-libs/alsa-lib-0.9.0 )"
DEPEND="${RDEPEND}
	nls? ( dev-util/intltool )"

S=${WORKDIR}/${MY_P}

src_compile() {
	local myconf=""

	econf \
		--with-dev-dsp=/dev/sound/dsp \
		--with-dev-mixer=/dev/sound/mixer \
		`use_enable oggvorbis vorbis` \
		`use_enable oggvorbis oggtest` \
		`use_enable oggvorbis vorbistest` \
		`use_enable esd` \
		`use_enable esd esdtest` \
		`use_enable mikmod` \
		`use_enable mikmod mikmodtest` \
		`use_with mikmod libmikmod` \
		`use_enable opengl` \
		`use_enable nls` \
		`use_enable alsa` \
		${myconf} \
		|| die

	emake || die "make failed"
}

src_install() {
	einstall || die "install failed"

	insinto /usr/share/pixmaps
	doins beep.svg
	doins beep/beep_mini.xpm

	# Get the app registered in gnome

	if use gnome; then
		insinto /usr/share/gnome/apps/Multimedia
		doins ${FILESDIR}/beep-media-player.desktop
	fi

	# We'll use xmms skins / plugins for the time being

	dodir /usr/share/beep
	dosym /usr/share/xmms/Skins /usr/share/beep/Skins
	dosym /usr/share/xmms/Plugins /usr/share/beep/Plugins

	dodoc AUTHORS ChangeLog COPYING FAQ NEWS README TODO
}

pkg_postinst() {
	echo
	einfo "This program is unstable on sparc when poking heavily with the GUI."
	einfo "It's reportedly unstable on some x86 boxes also, YMMV."
	echo
	einfo "We're using xmms skins/plugins for the time being, they have been symlinked."
	echo
}
