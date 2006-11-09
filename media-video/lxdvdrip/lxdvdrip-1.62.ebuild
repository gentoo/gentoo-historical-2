# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/lxdvdrip/lxdvdrip-1.62.ebuild,v 1.1 2006/11/09 18:53:01 aballier Exp $

inherit eutils toolchain-funcs

DESCRIPTION="command line tool to automate the process of ripping and burning DVD"
SRC_URI="http://download.berlios.de/lxdvdrip/${P}.tgz"
HOMEPAGE="http://developer.berlios.de/projects/lxdvdrip/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

DEPEND="media-libs/libdvdread"
RDEPEND="${DEPEND}
	>=media-video/dvdauthor-0.6.9
	media-video/streamdvd
	media-video/mpgtx
	media-video/vamps"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd ${S}
	cp "${FILESDIR}/${P}-makefile" "${S}/Makefile"
}

src_compile() {
	CC=$(tc-getCC) emake || die "emake failed"
}

src_install () {
	dobin lxdvdrip
	dobin lxac3scan
	dodoc doc-pak/*
	doman lxdvdrip.1

	insinto /usr/share
	doins lxdvdrip.wav

	insinto /etc
	newins doc-pak/lxdvdrip.conf.EN lxdvdrip.conf
}
