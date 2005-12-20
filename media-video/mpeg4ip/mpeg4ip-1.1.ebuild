# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mpeg4ip/mpeg4ip-1.1.ebuild,v 1.15 2005/12/20 05:43:45 tester Exp $

inherit eutils

DESCRIPTION="MPEG 4 implementation library"

HOMEPAGE="http://www.mpeg4ip.net/"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MPL-1.1 LGPL-2 GPL-2 LGPL-2.1 BSD UCL MPEG4"

SLOT="0"

KEYWORDS="x86 amd64"

IUSE="ipv6 mmx gtk v4l2 xvid nas alsa esd arts"

RDEPEND=">=media-libs/faac-1.20.1
	>=media-sound/lame-3.92
	gtk? ( >=x11-libs/gtk+-2 )
	media-libs/libid3tag
	xvid? ( media-libs/xvid )
	nas? ( media-libs/nas virtual/x11 )
	alsa? ( media-libs/alsa-lib )
	arts? ( kde-base/arts )
	esd? ( media-sound/esound )
	!media-libs/faad2
	!media-libs/libmp4v2"


DEPEND="${RDEPEND}
	sys-devel/libtool
	sys-devel/autoconf
	sys-devel/automake
	x86? ( mmx? ( >=dev-lang/nasm-0.98.19 ) )"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e 's/-Wmissing-prototypes//g' -e 's/-Werror//g' configure

	cd ${S}/lib/SDLAudio
	sed -i -e 's:-laudio:-L/usr/X11R6/lib -laudio:' configure

	cd ${S}
	epatch ${FILESDIR}/mpeg4ip-1.1-gcc3.4.patch
	epatch ${FILESDIR}/mpeg4ip-1.1-gentoo-fixes.patch

	# ships with old version of libtool, causes problems (bug #98133)
	libtoolize --copy --force
}

src_compile() {

	cd ${S}

	local myconf

	# mp4live doesnt build, disable it..
	myconf=" $(use_enable ipv6)
			$(use_enable mmx)
			$(use_enable ppc)
			$(use_enable nas)
			$(use_enable esd)
			$(use_enable alsa)
			$(use_enable arts)"
	use v4l2 || myconf="${myconf} --disable-v4l2"

	econf ${myconf} --with-pic || die "configure failed"

	cd ${S}
	emake || die "make failed"

}

src_install () {

	cd ${S}
	make install DESTDIR="${D}" || die "make install failed"

}
