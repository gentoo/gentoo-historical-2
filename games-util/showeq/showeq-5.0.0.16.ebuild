# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/showeq/showeq-5.0.0.16.ebuild,v 1.1 2004/12/29 10:18:23 mr_bones_ Exp $

inherit kde games

DESCRIPTION="A Everquest monitoring program"
HOMEPAGE="http://seq.sourceforge.net/"
SRC_URI="mirror://sourceforge/seq/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/x11
	media-libs/libpng
	>=net-libs/libpcap-0.6.2
	>=x11-libs/qt-3.1
	>=sys-libs/gdbm-1.8.0"

src_compile() {
	kde_src_compile nothing
	egamesconf || die
	emake || die "emake failed"
}

src_install() {
	egamesinstall || die
	doman showeq.1
	dodoc BUGS CHANGES FAQ INSTALL README* ROADMAP TODO doc/*.{doc,txt}
	dohtml doc/*
	prepgamesdirs
}
