# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/soundkonverter/soundkonverter-0.3.8-r1.ebuild,v 1.2 2009/02/14 06:31:17 mr_bones_ Exp $

ARTS_REQUIRED="never"

EAPI="1"

inherit kde eutils

DESCRIPTION="SoundKonverter: A frontend to various audio converters for KDE."
HOMEPAGE="http://kde-apps.org/content/show.php?content=29024"
SRC_URI="http://hessijames.googlepages.com/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ffmpeg flac mp3 musepack vorbis"

DEPEND=">=media-libs/taglib-1.4
	>=media-sound/cdparanoia-3.9.8-r5"
RDEPEND="${DEPEND}
	mp3? ( >=media-sound/lame-3.96 )
	vorbis? ( >=media-sound/vorbis-tools-1 )
	flac? ( >=media-libs/flac-1.1.1 )
	ffmpeg? ( >=media-video/ffmpeg-0.4.8 )
	musepack? ( >=media-sound/musepack-tools-1.15u )"

need-kde 3.5

PATCHES=(
	"${FILESDIR}/${PN}-0.3.6-gcc43.patch"
	"${FILESDIR}/soundkonverter-0.3.8-desktop-file.diff"
	)

src_compile() {
	append-flags -fno-inline
	local myconf="--without-mp4v2"
	kde_src_compile || die "kde_src_compile failed."
}

src_install() {
	kde_src_install || die "kde_src_install failed."
	mv "${D}"/usr/share/doc/HTML "${D}"/usr/share/doc/${PF}/html
}

pkg_postinst() {
	kde_pkg_postinst

	elog "The audio USE flags are for your convience, but are not required."
	elog "For AmaroK users there is a script included with this package."
	elog "You can enable it with the Script Manager tool in Amarok, after"
	elog "installing kde-base/qtruby."
}
