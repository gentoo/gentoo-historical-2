# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/lame/lame-3.98.4.ebuild,v 1.3 2010/08/23 20:06:34 ssuominen Exp $

EAPI=2
inherit autotools eutils

DESCRIPTION="LAME Ain't an MP3 Encoder"
HOMEPAGE="http://lame.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="debug mmx mp3rtp sndfile static-libs"

RDEPEND=">=sys-libs/ncurses-5.2
	sndfile? ( >=media-libs/libsndfile-1.0.2 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	mmx? ( dev-lang/nasm )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-3.98-shared-frontend.patch \
		"${FILESDIR}"/${PN}-3.96-ccc.patch \
		"${FILESDIR}"/${PN}-3.98-gtk-path.patch \
		"${FILESDIR}"/${PN}-3.98.2-get_audio.patch

	mkdir libmp3lame/i386/.libs || die #workaround parallel build with nasm

	AT_M4DIR="${S}" eautoreconf
	epunt_cxx #74498
}

src_configure() {
	local myconf
	use sndfile && myconf="--with-fileio=sndfile"

	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static) \
		$(use_enable debug debug norm) \
		$(use_enable mmx nasm) \
		--disable-mp3x \
		$(use_enable mp3rtp) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" pkghtmldir="/usr/share/doc/${PF}/html" install || die
	dobin misc/mlame || die

	dodoc API ChangeLog HACKING README* STYLEGUIDE TODO USAGE || die
	dohtml misc/lameGUI.html Dll/LameDLLInterface.htm || die

	find "${D}" -name '*.la' -exec rm -f '{}' +
}
