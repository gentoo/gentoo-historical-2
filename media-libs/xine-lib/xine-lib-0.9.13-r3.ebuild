# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/xine-lib/xine-lib-0.9.13-r3.ebuild,v 1.5 2003/09/06 23:59:49 msterret Exp $

IUSE="arts esd avi nls dvd aalib X directfb oggvorbis alsa"

inherit libtool

# this build doesn't play nice with -maltivec (gcc 3.2 only option) on ppc
inherit flag-o-matic
filter-flags "-maltivec -mabi=altivec"
replace-flags k6-3 i686
replace-flags k6-2 i686
replace-flags k6   i686

S=${WORKDIR}/${P}
DESCRIPTION="Xine is a free gpl-licensed video player for unix-like systems"
HOMEPAGE="http://xine.sourceforge.net/"
SRC_URI="mirror://sourceforge/xine/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc "

DEPEND="oggvorbis? ( media-libs/libvorbis )
	X? ( virtual/x11 )
	avi? ( x86? ( >=media-libs/win32codecs-0.50
	       media-libs/divx4linux ) )
	esd? ( media-sound/esound )
	dvd? ( >=media-libs/libdvdcss-0.0.3.3
	       >=media-libs/libdvdread-0.9.2 )
	arts? ( kde-base/arts )
	alsa? ( media-libs/alsa-lib )
	aalib? ( media-libs/aalib )
	directfb? ( >=dev-libs/DirectFB-0.9.9
		    dev-util/pkgconfig )"

RDEPEND="${DEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {

	unpack ${A}
	cd ${S}

	patch -p1 < ${FILESDIR}/xine-lib-configure.patch || \
	    die "configure patch failed"

	# allows kxine to work; see bug #5412
	patch -p1 < ${FILESDIR}/${P}-kxine.patch || \
	    die "patching for kxine support failed"

	if [ `use directfb` ]; then
		patch -p0 < ${FILESDIR}/xineconfig.patch-${PV} || \
		    die "dfb patch 1 failed"
#		patch -p2 < ${FILESDIR}/${PF}-directfb.patch || \
#		    die "dfb patch 2 failed"
	else
		patch -p1 < ${FILESDIR}/${PN}-disable-directfb.patch || \
		    die "no dfb patch failed"
	fi
}

src_compile() {

	elibtoolize

	# Most of these are not working currently, but are here for completeness
	# don't use the --disable-XXXtest because that defaults to ON not OFF
	local myconf
	use X \
		|| myconf="${myconf} --disable-x11 --disable-xv"
	use esd	\
		|| myconf="${myconf} --disable-esd"
	# --disable-esdtest"
	use nls	\
		|| myconf="${myconf} --disable-nls"
	use alsa \
		|| myconf="${myconf} --disable-alsa"
	# --disable-alsatest"
	use arts \
		|| myconf="${myconf} --disable-arts"
	# --disable-artstest"

	# This breaks because with the test disabled, it defaults to
	# "found" check with the next release until then let it autodetect.
	# See bug #2377.
	use aalib  || myconf="${myconf} --disable-aalib"
		# --disable-aalibtest"

	# Configure script is broken, even if you pass the flags below it
	# still assumes ogg is installed and tries to compile it, giving you
	# bug #5244. But leaving ogg for autodetection works.
	use oggvorbis \
		|| myconf="${myconf} --disable-ogg --disable-vorbis"
#			 --disable-oggtest \
#			 --disable-vorbistest"

	use avi	\
		&& myconf="${myconf} --with-w32-path=/usr/lib/win32" \
		|| myconf="${myconf} --disable-asf"

	einfo "myconf: ${myconf}"

	econf ${myconf} || die

	elibtoolize

	emake || die
}

src_install() {

	make DESTDIR=${D} install || die

	# Xine's makefiles install some file incorrectly. (Bug #8583).
	dodir /usr/share/xine/fonts
	mv ${D}/usr/share/*.xinefont.gz ${D}/usr/share/xine/fonts/
	dodir /usr/share/xine/skins
	mv ${D}/usr/share/xine_logo.mpv ${D}/usr/share/xine/skins/

	dodoc AUTHORS COPYING ChangeLog INSTALL README TODO
	cd ${S}/doc
	dodoc dataflow.dia README*

}

pkg_postinst() {

	einfo
	einfo "Please note, a new version of xine-lib has been installed,"
	einfo "for library consistency you need to unmerge old versions"
	einfo "of xine-lib before merging xine-ui."
	einfo

}
