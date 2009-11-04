# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libfishsound/libfishsound-0.9.2.ebuild,v 1.2 2009/11/04 15:48:11 mr_bones_ Exp $

DESCRIPTION="Simple programming interface for decoding and encoding audio data using vorbis or speex"
HOMEPAGE="http://www.annodex.net/software/libfishsound/html/"
SRC_URI="http://www.annodex.net/software/libfishsound/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc speex"

RDEPEND="media-libs/libvorbis media-libs/libogg
	speex? ( media-libs/speex )"
#	flac? ( media-libs/flac )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen virtual/latex-base )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	use doc || sed -i -e "s/doxygen/doxygen-dummy/" configure
	rm -rf "${S}/doc/libfishsound"
}

src_compile() {
	local myconf=""
	# use flac ||
	# disable it for now, it causes compile failures in sonic-visualiser because
	# it adds -I/usr/include/FLAC to pkgconfig cflags...
	myconf="$myconf --disable-flac"
	use speex || myconf="$myconf --disable-speex"
	econf $myconf

	emake || die "emake failed"
	if use doc; then
		export VARTEXFONTS="${T}/fonts"
		cd "${S}/doc/libfishsound/latex"
		emake refman.ps || die "failed to create refman.ps"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README
}
