# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mp3blaster/mp3blaster-3.2.3.ebuild,v 1.2 2007/03/01 18:54:46 aballier Exp $

inherit toolchain-funcs

DESCRIPTION="Command line MP3 player."
HOMEPAGE="http://mp3blaster.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~sparc ~x86"
LICENSE="GPL-2"
IUSE="lirc mysql vorbis"

DEPEND=">=sys-libs/ncurses-5.2
	mysql? ( virtual/mysql )
	lirc? ( app-misc/lirc )
	vorbis? ( >=media-libs/libvorbis-1.0_beta1 )"

src_compile() {
	local myconf
	# Prevents collisions with media-sound/splay
	sed -i "s/splay.1/splay_mp3blaster.1/" Makefile.in\
		|| die "sedding makefile failed"
	mv splay.1 splay_mp3blaster.1 || die "renaming splay man failed"
	### Looks like NAS support is broken, at least with NAS 1.5 and
	### mp3player 3.1.1 (Aug 13, agenkin@thpoon.com)
	### Ditto nas-1.6c-r1, mp3blaster-3.2.0 (2004.06.23 - eradicator)
	myconf="${myconf} --without-nas \
	        `use_with lirc` \
	        `use_with mysql` \
	        `use_with vorbis oggvorbis`"

	econf ${myconf} || die
	make CC="$(tc-getCC) ${CFLAGS}" CXX="$(tc-getCXX) ${CXXFLAGS}" || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	# Prevent collisions with media-sound/splay
	mv "${D}/usr/bin/splay" "${D}/usr/bin/splay_mp3blaster"\
		|| die "moving splay to splay_mp3blaster failed"
	dodoc ANNOUNCE AUTHORS CREDITS ChangeLog FAQ NEWS README TODO
}
