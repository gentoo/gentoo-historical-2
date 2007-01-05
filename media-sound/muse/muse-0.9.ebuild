# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/muse/muse-0.9.ebuild,v 1.8 2007/01/05 17:41:06 flameeyes Exp $

IUSE="ncurses gtk debug"

inherit eutils

MY_P=${PN/muse/MuSE}-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Multiple Streaming Engine, an icecast source streamer"
SRC_URI="ftp://ftp.dyne.org/muse/releases/${MY_P}.tar.gz"
HOMEPAGE="http://muse.dyne.org/"

KEYWORDS="~ppc sparc x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="media-sound/lame
	media-libs/libvorbis
	sys-libs/zlib
	sys-apps/sed
	ncurses? ( sys-libs/ncurses )
	gtk? ( =x11-libs/gtk+-1*
	>=dev-libs/glib-1 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-locale-Makefile.patch
}

src_compile() {
	econf \
	`use_with gtk x` \
	`use_with ncurses rubik` \
	`use_enable debug` || die "econf failed"

	emake CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	rm -rf ${D}/usr/doc
	dodoc AUTHORS ChangeLog NEWS README TODO KNOWN-BUGS USAGE
}

pkg_postinst() {
	elog
	elog "You may want to have a look at /usr/share/doc/${PF}/README.gz for more info."
	elog
}
