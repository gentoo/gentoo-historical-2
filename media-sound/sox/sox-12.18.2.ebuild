# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sox/sox-12.18.2.ebuild,v 1.4 2007/08/05 16:16:37 drac Exp $

inherit flag-o-matic eutils

DESCRIPTION="The swiss army knife of sound processing programs"
HOMEPAGE="http://sox.sourceforge.net"
SRC_URI="mirror://sourceforge/sox/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="alsa encode mad ogg"

DEPEND="virtual/libc
	alsa? ( media-libs/alsa-lib )
	encode? ( media-sound/lame )
	mad? ( media-libs/libmad )
	ogg? ( media-libs/libvorbis )"

src_unpack() {
	unpack ${A}

	cd ${S}

	epatch ${FILESDIR}/${P}-destdir.patch
	epatch ${FILESDIR}/sox-12.17.9-largefile.patch

	autoheader || die "autoheader failed"
	autoconf || die "autoconf failed"
}

src_compile () {
	# Fixes wav segfaults. See Bug #35745.
	append-flags -fsigned-char

	econf ${myconf} \
		$(use_enable alsa alsa-dsp) \
		$(use_enable encode lame) \
		$(use_enable mad) \
		$(use_enable ogg ogg-vorbis) \
		--enable-oss-dsp \
		--enable-fast-ulaw \
		--enable-fast-alaw \
		|| die "configure failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install install-play || die "make install failed"
	dodoc Changelog README TODO *.txt
}
