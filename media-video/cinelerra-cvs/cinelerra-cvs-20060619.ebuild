# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/cinelerra-cvs/cinelerra-cvs-20060619.ebuild,v 1.4 2007/01/05 20:29:55 flameeyes Exp $

inherit toolchain-funcs eutils flag-o-matic

#filter-flags "-fPIC -fforce-addr"

RESTRICT="nostrip"

DESCRIPTION="Cinelerra - Professional Video Editor - Unofficial CVS-version"
HOMEPAGE="http://cvs.cinelerra.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="3dnow alsa esd mmx oss static"

RDEPEND="!media-video/cinelerra
	media-libs/libpng
	>=media-libs/libdv-0.104
	media-libs/faad2
	media-libs/faac
	media-libs/a52dec
	media-video/ffmpeg
	sci-libs/fftw
	>=media-libs/x264-svn-20060302
	media-libs/libiec61883
	media-libs/libmpeg3
	media-video/mjpegtools
	>=sys-libs/libavc1394-0.5.0
	>=sys-libs/libraw1394-0.9.0
	esd? ( >=media-sound/esound-0.2.34 )
	>=media-libs/openexr-1.2.2
	>=media-libs/libvorbis-1.1.0
	>=media-libs/libogg-1.1
	>=media-libs/libtheora-1.0_alpha4-r1
	|| ( (
			x11-libs/libX11
			x11-libs/libXv
			x11-libs/libXxf86vm
			x11-libs/libXext
			x11-libs/libXvMC
			x11-libs/libXft
		) virtual/x11 )"

DEPEND="${RDEPEND}
	x86? ( dev-lang/nasm )"

pkg_setup() {
	if [[ "$(gcc-major-version)" -lt "3" ]]; then
		die "You must use gcc 3 or better."
	fi
}

src_compile() {
	cd ${S}
	export WANT_AUTOMAKE=1.7
	export WANT_AUTOCONF=2.5
#	sed -e s/libmpeg3//1 -i ${S}/Makefile.am
	cd ${S}
	./autogen.sh
	econf \
	`use_enable static` \
	`use_enable alsa` \
	`use_enable esd` \
	`use_enable oss` \
	`use_enable mmx` \
	`use_enable 3dnow` \
	--with-plugindir=/usr/$(get_libdir)/cinelerra \
	|| die "configure failed"
	make || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die
	dohtml -a png,html,texi,sdw -r doc/*
	# workaround
	rm -fR ${D}/usr/include
	mv ${D}/usr/bin/mpeg3cat ${D}/usr/bin/mpeg3cat.hv
	mv ${D}/usr/bin/mpeg3dump ${D}/usr/bin/mpeg3dump.hv
	mv ${D}/usr/bin/mpeg3toc ${D}/usr/bin/mpeg3toc.hv
	ln -s /usr/bin/mpeg2enc ${D}/usr/lib/cinelerra/mpeg2enc.plugin
}

pkg_postinst () {

elog "Please note that this is unofficial and somewhat experimental code."
elog "See cvs.cinelerra.org for a list of changes to the official cinelerra"
elog "release."
}
