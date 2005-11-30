# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/lxdvdrip/lxdvdrip-1.20_pre1.ebuild,v 1.1 2004/08/30 23:15:59 tantive Exp $

inherit eutils

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="command line tool to automate the process of ripping and burning DVD"
SRC_URI="http://download.berlios.de/lxdvdrip/${MY_P}.tgz"
HOMEPAGE="http://developer.berlios.de/projects/lxdvdrip/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=">=dvdauthor-0.6.9"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd ${S} || die
	sed -ie "s/gcc -g/\$(CC) \$(CFLAGS)/g" Makefile
}

src_compile() {
	emake || die
}

src_install () {
	dobin lxdvdrip
	dodoc doc-pak/*
	insinto /etc
	newins doc-pak/lxdvdrip.conf.EN lxdvdrip.conf
}
