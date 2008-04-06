# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libfishsound/libfishsound-0.9.0.ebuild,v 1.1 2008/04/06 20:15:23 aballier Exp $

inherit eutils

DESCRIPTION="Simple programming interface for decoding and encoding audio data using Xiph.Org codecs (Vorbis and Speex)"
HOMEPAGE="http://www.annodex.net/software/libfishsound/html/"
SRC_URI="http://www.annodex.net/software/libfishsound/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc vorbis"

RDEPEND="vorbis? ( media-libs/libvorbis media-libs/libogg )
	media-libs/speex"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen virtual/latex-base )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	use doc || sed -i -e "s/doxygen/doxygen-dummy/" configure
	rm -rf "${S}/doc/libfishsound"
	epatch "${FILESDIR}/${P}-ocert-2008-2.patch"
}

src_compile() {
	local myconf
	use vorbis || myconf="--disable-vorbis"
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
