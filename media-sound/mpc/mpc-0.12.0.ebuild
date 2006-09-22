# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mpc/mpc-0.12.0.ebuild,v 1.1 2006/09/22 18:39:59 ticho Exp $

inherit bash-completion

DESCRIPTION="A commandline client for Music Player Daemon (media-sound/mpd)"
SRC_URI="http://musicpd.org/uploads/files/${P}.tar.bz2"
HOMEPAGE="http://www.musicpd.org"
IUSE="nls"

KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/libc
	nls? ( || ( sys-libs/glibc dev-libs/libiconv ) )"

src_compile() {
	econf --disable-dependency-tracking \
		$(use_enable nls iconv) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die
	mv ${D}/usr/share/doc/mpc/ ${D}/usr/share/doc/${PF}

	dobashcompletion doc/mpc-bashrc
}
