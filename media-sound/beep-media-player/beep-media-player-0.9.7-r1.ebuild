# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/beep-media-player/beep-media-player-0.9.7-r1.ebuild,v 1.5 2005/01/03 22:26:34 gustavoz Exp $

IUSE="nls gnome mp3 oggvorbis alsa oss esd mmx old-eq"

inherit flag-o-matic eutils

MY_PN="bmp"
MY_P=bmp-${PV/_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Beep Media Player"
HOMEPAGE="http://www.sosdg.org/~larne/w/BMP_Homepage"
SRC_URI="mirror://sourceforge/beepmp/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~hppa"

RDEPEND="app-arch/unzip
	>=x11-libs/gtk+-2.4
	>=x11-libs/pango-1.2
	>=gnome-base/libglade-2.3.1
	esd? ( >=media-sound/esound-0.2.30 )
	oggvorbis? ( >=media-libs/libvorbis-1.0 )
	alsa? ( >=media-libs/alsa-lib-1.0 )
	gnome? ( >=gnome-base/gnome-vfs-2.6.0
	         >=gnome-base/gconf-2.6.0 )"

DEPEND="${RDEPEND}
	nls? ( dev-util/intltool )"

src_unpack() {
	if ! useq mp3; then
		ewarn "MP3 support is now optional and you have not enabled it."
	fi

	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-noclick-resize.patch
}

src_compile() {
	# Bug #42893
	replace-flags "-Os" "-O2"

	econf \
		--with-dev-dsp=/dev/sound/dsp \
		--with-dev-mixer=/dev/sound/mixer \
		--includedir=/usr/include/beep-media-player \
		`use_with old-eq xmms-eq` \
		`use_enable mmx simd` \
		`use_enable gnome gconf` \
		`use_enable oggvorbis vorbis` \
		`use_enable esd` \
		`use_enable mp3` \
		`use_enable nls` \
		`use_enable oss` \
		`use_enable alsa` \
		|| die

	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die

	insinto /usr/share/pixmaps
	doins icons/bmp.svg
	doins beep/beep_logo.xpm

	dosym /usr/include/beep-media-player/bmp /usr/include/beep-media-player/xmms

	# XMMS skin symlinking; bug 70697
	for SKIN in /usr/share/xmms/Skins/* ; do
		dosym "$SKIN" /usr/share/bmp/Skins/
	done

	# Plugins want beep-config, this wasn't included
	# Note that this one has a special gentoo modification
	# to work with xmms-plugin.eclass
	dobin ${FILESDIR}/beep-config

	dodoc AUTHORS FAQ NEWS README TODO
}

pkg_postinst() {
	echo
	einfo "Your XMMS skins, if any, have been symlinked."
	einfo "MP3 support is now optional, enable the mp3 USE-flag if you want this."
	echo
}
