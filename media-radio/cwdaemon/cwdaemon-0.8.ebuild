# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-radio/cwdaemon/cwdaemon-0.8.ebuild,v 1.3 2004/06/30 02:42:53 killsoft Exp $

inherit eutils

DESCRIPTION="A morse daemon for the parallel or serial port"
HOMEPAGE="http://www.qsl.net/pg4i/linux/cwdaemon.html"
SRC_URI="http://www.qsl.net/pg4i/download/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

RDEPEND="virtual/libc"
DEPEND="sys-apps/gawk"

src_compile() {
	econf || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die
}
