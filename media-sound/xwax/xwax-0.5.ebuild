# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/xwax/xwax-0.5.ebuild,v 1.1 2009/07/07 04:00:25 nixphoeni Exp $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="Digital vinyl emulation software"
HOMEPAGE="http://www.xwax.co.uk/"
SRC_URI="http://www.xwax.co.uk/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa jack"

RDEPEND="media-libs/libsdl
	media-libs/sdl-ttf
	media-fonts/ttf-bitstream-vera
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )"
DEPEND="${RDEPEND}"

src_prepare() {
	# Remove the forced optimization from 'CFLAGS' and the 'LDFLAGS' line
	# from Makefile
	sed -i -e 's:^CFLAGS.*:CFLAGS += -MMD:' \
		-e 's:^LDFLAGS:#LDFLAGS:' \
		Makefile || die "sed failed"
}

src_configure() {
	tc-export CC
	econf \
		$(use_enable alsa) \
		$(use_enable jack)
}

src_install() {
	dobin xwax xwax_import || die
	dodoc README CHANGES || die
}
