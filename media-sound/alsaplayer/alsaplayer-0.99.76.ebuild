# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsaplayer/alsaplayer-0.99.76.ebuild,v 1.15 2005/04/20 19:11:29 luckyduck Exp $

inherit eutils

IUSE="nas nls esd opengl doc oss gtk vorbis alsa jack mikmod flac"

DESCRIPTION="Media player primarily utilising ALSA"
HOMEPAGE="http://www.alsaplayer.org/"
SRC_URI="http://www.alsaplayer.org/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ~ia64 ppc ~sparc x86 ~mips"

RDEPEND=">=dev-libs/glib-1.2.10
	media-libs/libsndfile
	doc? ( app-doc/doxygen )
	esd? ( media-sound/esound )
	gtk? ( =x11-libs/gtk+-1* )
	nas? ( media-libs/nas )
	alsa? ( media-libs/alsa-lib )
	jack? ( >=media-sound/jack-audio-connection-kit-0.80.0 )
	flac? ( media-libs/flac )
	mikmod? ( >=media-libs/libmikmod-3.1.10 )
	opengl? ( virtual/opengl )
	vorbis? ( media-libs/libvorbis )"

DEPEND="${RDEPEND}
	sys-apps/sed
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd ${S}
	if use ppc; then
		epatch ${FILESDIR}/alsaplayer-endian.patch
	fi
}

src_compile() {
	export CPPFLAGS="${CPPFLAGS} -I/usr/X11R6/include"

	econf \
		`use_enable oss` \
		`use_enable nas` \
		`use_enable opengl` \
		`use_enable nls` \
		`use_enable sparc` \
		`use_enable vorbis oggvorbis` \
		`use_enable esd` \
		`use_enable gtk` \
		`use_enable jack` \
		`use_enable mikmod` \
		`use_enable flac` \
		--disable-sgi || die

	emake || die
}

src_install() {

	make DESTDIR=${D} docdir=${D}/usr/share/doc/${PF} install

	dodoc AUTHORS ChangeLog README TODO
	dodoc docs/wishlist.txt
}
