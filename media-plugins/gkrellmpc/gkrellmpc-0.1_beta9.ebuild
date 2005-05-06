# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gkrellmpc/gkrellmpc-0.1_beta9.ebuild,v 1.3 2005/05/06 15:01:19 swegener Exp $

IUSE=""
DESCRIPTION="A gkrellm plugin to control the MPD (Music Player Daemon)"
HOMEPAGE="http://mpd.wikicities.com/wiki/Client:GKrellMPC"
SRC_URI="http://www.topfx.com/dist/${P}.tar.gz"
IUSE=""
DEPEND=">=app-admin/gkrellm-2
	net-misc/curl"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

src_install () {
	exeinto /usr/lib/gkrellm2/plugins
	doexe gkrellmpc.so gkrellmpc.so
	dodoc README.txt Changelog
}
