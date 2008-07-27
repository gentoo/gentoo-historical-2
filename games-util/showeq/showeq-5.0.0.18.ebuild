# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/showeq/showeq-5.0.0.18.ebuild,v 1.10 2008/07/27 21:39:23 carlo Exp $

EAPI=1

inherit kde games

DESCRIPTION="A Everquest monitoring program"
HOMEPAGE="http://seq.sourceforge.net/"
SRC_URI="mirror://sourceforge/seq/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE=""

DEPEND="x11-libs/libXt
	media-libs/libpng
	virtual/libpcap
	x11-libs/qt:3
	>=sys-libs/gdbm-1.8.0"

src_unpack() {
	mkdir "${WORKDIR}"/patches
	cp "${FILESDIR}"/${P}-*.patch "${WORKDIR}"/patches
	kde_src_unpack
}

src_compile() {
	kde_src_compile nothing
	egamesconf || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	doman showeq.1
	dodoc BUGS FAQ README* ROADMAP TODO doc/*.{doc,txt}
	dohtml doc/*
	prepgamesdirs
}
