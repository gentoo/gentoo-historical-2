# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/yammi/yammi-1.0.ebuild,v 1.4 2004/04/01 08:47:12 eradicator Exp $

inherit flag-o-matic eutils

DESCRIPTION="MP3/Ogg/Wav-Manager and Jukebox 4 XMMS/Noatun"
HOMEPAGE="http://yammi.sourceforge.net/"
SRC_URI="mirror://sourceforge/yammi/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="cdr xmms oggvorbis kde"

DEPEND=">=x11-libs/qt-3.1.0-r1
	>=media-libs/id3lib-3.8.2
	>=media-sound/cdparanoia-3.9.8
	>=media-sound/lame-3.93.1
	virtual/mpg123
	>=media-sound/sox-12.17.3-r1
	cdr? ( >=app-cdr/cdlabelgen-2.4.0 >=app-cdr/mp3burn-0.1 )
	xmms? ( >=media-sound/xmms-1.2.7-r18 )
	oggvorbis? ( >=media-libs/libvorbis-1.0-r1 >=media-sound/vorbis-tools-1.0-r1 )
	kde? ( >=kde-base/kdebase-3.0.4 )"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-qt.patch
}

src_compile() {
	# need to filter -fomit-frame-pointer for pentium II
	is-flag "-march=pentium2" && filter-flags "-fomit-frame-pointer"

	#needed to let configure detect the id3libs correct
	export LDFLAGS="-lstdc++"

	local myconf
	use xmms || myconf="--disable-xmms"
	use kde || myconf="--disable-KDE --disable-noatun ${myconf}"

	if [ -z "`use xmms`" ] && [ -z "`use kde`" ]
	then
		myconf="--disable-ogglibs ${myconf}"
	else
		use oggvorbis || myconf="--disable-oogvorbis ${myconf}"
	fi

	econf ${myconf} || die "./configure failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR=$D install || die
	dodoc AUTHORS CHANGELOG CREDITS INSTALL README TODO
}

pkg_postinst() {
	if [ -z "`use kde`" ] && [ -z "`use xmms`" ]
	then
		ewarn "Yammi is compiled without support for xmms and noatun."
		ewarn "Now the functionality of Yammi is very limited."
		ewarn "It is highly recommended to recompile Yammi."
		ewarn
		ewarn "To get xmms support:"
		ewarn "$ export USE=\"xmms\""
		ewarn
		ewarn "To get noatun support:"
		ewarn "$ export USE=\"kde\""
		ewarn
		ewarn "Or to get support for both:"
		ewarn "$ export USE=\"xmms kde\""
	fi
}
