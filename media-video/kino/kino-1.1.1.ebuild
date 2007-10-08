# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/kino/kino-1.1.1.ebuild,v 1.5 2007/10/08 17:30:23 corsair Exp $

DESCRIPTION="Kino is a non-linear DV editor for GNU/Linux"
HOMEPAGE="http://www.kinodv.org/"
SRC_URI="mirror://sourceforge/kino/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc x86"
IUSE="alsa dvdr gpac quicktime sox vorbis"

DEPEND=">=x11-libs/gtk+-2.6.0
	>=gnome-base/libglade-2.5.0
	>=dev-libs/glib-2
	x11-libs/libXv
	dev-libs/libxml2
	media-libs/audiofile
	>=sys-libs/libraw1394-1.0.0
	>=sys-libs/libavc1394-0.4.1
	>=media-libs/libdv-0.103
	media-libs/libsamplerate
	!sparc? ( media-libs/libiec61883 )
	alsa? ( >=media-libs/alsa-lib-1.0.9 )
	>=media-video/ffmpeg-0.4.9_p20061016
	quicktime? ( || ( >=media-libs/libquicktime-0.9.5 media-video/cinelerra-cvs ) )"
RDEPEND="${DEPEND}
	media-video/mjpegtools
	media-sound/rawrec
	dvdr? ( media-video/dvdauthor
		app-cdr/dvd+rw-tools )
	gpac? ( !sparc? ( media-video/gpac ) )
	sox? ( media-sound/sox )
	vorbis? ( media-sound/vorbis-tools )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix to link with --as-needed
	sed -i -e 's:LIBS="-lXext:LIBS="-lXext -lX11:' configure || die "sed failed"

	# Deactivating automagic alsa configuration, bug #134725
	if ! use alsa ; then
		sed -i -e "s:HAVE_ALSA 1:HAVE_ALSA 0:" configure || die "sed failed"
	fi

	# Fix bug #169590
	sed -i \
		-e '/\$(LIBQUICKTIME_LIBS) \\/d' \
		-e '/^[[:space:]]*\$(SRC_LIBS)/ a\
	\$(LIBQUICKTIME_LIBS) \\' \
		src/Makefile.in || die "sed failed"

	# Fix bug #172687
	sed -i \
		-e 's/^install-exec-local:/install-exec-local: install-binPROGRAMS/' \
		src/Makefile.in || die "sed failed"

	# Fix test failure discovered in bug #193947
	sed -i -e '$a\
\
ffmpeg/libavcodec/ps2/idct_mmi.c\
ffmpeg/libavcodec/sparc/dsputil_vis.c\
ffmpeg/libavcodec/sparc/vis.h\
ffmpeg/libavutil/bswap.h\
ffmpeg/libswscale/yuv2rgb_template.c\
src/export.h\
src/message.cc\
src/page_bttv.cc' po/POTFILES.in || die "sed failed"
}

src_compile() {
	econf \
		--disable-dependency-tracking \
		--disable-debug \
		--disable-local-ffmpeg \
		$(use_enable quicktime) \
		$(use_with sparc dv1394) \
		|| die "Configuration failed"
	emake || die "Compilation failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"
	dodoc AUTHORS BUGS ChangeLog NEWS README* TODO
	# Fix bug #177378
	fowners root:root -R /usr/share/kino/help
}
