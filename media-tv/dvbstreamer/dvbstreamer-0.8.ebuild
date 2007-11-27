# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/dvbstreamer/dvbstreamer-0.8.ebuild,v 1.2 2007/11/27 10:17:10 zzam Exp $

inherit multilib

DESCRIPTION="DVB over UDP streaming solution"
HOMEPAGE="http://dvbstreamer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/libdvbpsi-0.1.5
	>=dev-db/sqlite-3
	sys-libs/readline"

DEPEND="${RDEPEND}
	media-tv/linuxtv-dvb-headers"

src_unpack() {
	unpack ${A}
	# delete unneeded linking against libtermcap
	sed -i "${S}"/src/Makefile* -e 's:-ltermcap::'
}

src_compile() {
	econf --libdir=/usr/$(get_libdir) || die "configure failed"
	emake || die "make failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "make install failed"
	rm -rf "${D}"/usr/doc/DVBStreamer/

	dodoc doc/*.txt ChangeLog README AUTHORS NEWS TODO || die "dodoc failed"
}
