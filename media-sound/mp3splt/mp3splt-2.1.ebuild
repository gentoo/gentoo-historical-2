# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mp3splt/mp3splt-2.1.ebuild,v 1.1 2004/11/21 21:41:37 eradicator Exp $

IUSE="oggvorbis"

DESCRIPTION="A command line utility to split mp3 and ogg files"
HOMEPAGE="http://mp3splt.sourceforge.net/"
SRC_URI="mirror://sourceforge/mp3splt/${P}-src.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"

DEPEND="oggvorbis? ( media-libs/libogg
	             media-libs/libvorbis )
	media-libs/libmad"

src_compile() {
	econf $(use_enable oggvorbis ogg) || die "econf failed"

	emake || die "build failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}
