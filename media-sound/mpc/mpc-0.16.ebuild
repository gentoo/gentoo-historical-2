# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mpc/mpc-0.16.ebuild,v 1.1 2009/05/25 20:22:16 angelos Exp $

EAPI=2
inherit bash-completion

DESCRIPTION="A commandline client for Music Player Daemon (media-sound/mpd)"
HOMEPAGE="http://www.musicpd.org"
SRC_URI="mirror://sourceforge/musicpd/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="iconv"

RDEPEND="iconv? ( virtual/libiconv )"
DEPEND="${RDEPEND}"

src_configure() {
	econf --disable-dependency-tracking \
		$(use_enable iconv)
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS NEWS README
	dodoc doc/mpd-m3u-handler.sh doc/mppledit doc/mpd-pls-handler.sh
	rm -rf "${D}"/usr/share/doc/${PN}
	rmdir "${D}"/usr/share/${PN}

	dobashcompletion doc/mpc-bashrc
}
