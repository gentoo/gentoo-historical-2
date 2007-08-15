# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/streamripper/streamripper-1.62.2.ebuild,v 1.7 2007/08/15 01:14:21 angelos Exp $

inherit eutils

DESCRIPTION="Extracts and records individual MP3 file tracks from shoutcast streams"
HOMEPAGE="http://streamripper.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ppc ppc64 sparc x86"
IUSE="vorbis"

RDEPEND="media-libs/libmad
	vorbis? ( media-libs/libogg media-libs/libvorbis )
	>=dev-libs/tre-0.7.2"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-implicit-declarations.patch
}

src_compile() {
	econf $(use_with vorbis ogg) \
		--without-included-libmad \
		--without-included-tre
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc CHANGES README parse_rules.txt THANKS
}
