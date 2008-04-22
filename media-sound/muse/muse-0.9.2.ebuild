# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/muse/muse-0.9.2.ebuild,v 1.6 2008/04/22 19:09:42 drac Exp $

inherit eutils

MY_P=${P/muse/MuSE}

DESCRIPTION="Multiple Streaming Engine, an icecast source streamer"
HOMEPAGE="http://muse.dyne.org"
SRC_URI="ftp://ftp.dyne.org/muse/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="debug gtk"

RDEPEND="media-sound/lame
	media-libs/libvorbis
	media-libs/libsndfile
	media-libs/libogg
	gtk? ( >=x11-libs/gtk+-2 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${P}-gcc43.patch
}

src_compile() {
	econf $(use_enable debug) $(use_enable gtk gtk2)
	emake CXXFLAGS="${CXXFLAGS} -fpermissive" CFLAGS="${CFLAGS}" \
		|| die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" docsdir="/usr/share/doc/${PF}" \
		install || die "emake install failed."
	prepalldocs
}
