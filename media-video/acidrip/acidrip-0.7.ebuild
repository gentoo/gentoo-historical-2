# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/acidrip/acidrip-0.7.ebuild,v 1.2 2003/03/11 21:11:46 seemant Exp $

inherit perl-module

DESCRIPTION="A gtk-perl mplayer/mencoder frontend for ripping DVDs"
HOMEPAGE="http://acidrip.thirtythreeandathird.net"
SRC_URI="mirror://sourceforge/acidrip/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE="encode"

DEPEND="dev-lang/perl
		dev-perl/gtk-perl
		media-video/lsdvd
		media-video/mplayer
		encode? ( >=media-sound/lame-3.92 )"

src_compile() {
	perl-module_src_compile
}

src_install() {
	perl-module_src_install
	#dobin acidrip
	dodoc Documentation/*
}
