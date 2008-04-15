# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mplayer/mplayer-1.0_rc2_p24929-r4.ebuild,v 1.1 2008/04/15 02:22:32 beandog Exp $

inherit eutils flag-o-matic multilib

RESTRICT="strip"
IUSE="3dnow 3dnowext a52 aac aalib alsa altivec amrnb amrwb arts bidi bl bindist
cddb cdio cdparanoia cpudetection custom-cflags debug dga doc dts dvb directfb
dvd dv enca encode esd fbcon ftp gif ggi gtk iconv ipv6 jack joystick jpeg
kernel_linux ladspa libcaca lirc live livecd lzo mad md5sum mmx mmxext mp2 mp3
musepack nas nemesi unicode vorbis opengl openal oss png pnm pulseaudio quicktime radio rar real rtc samba sdl speex srt sse sse2 ssse3 svga teletext tga theora tivo truetype v4l v4l2 vidix win32codecs X x264 xanim xinerama xv xvid xvmc zoran"

VIDEO_CARDS="s3virge mga tdfx vesa"

for x in ${VIDEO_CARDS}; do
	IUSE="${IUSE} video_cards_${x}"
done

BLUV="1.7"
SVGV="1.9.17"
AMR_URI="http://www.3gpp.org/ftp/Specs/archive"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	!truetype? ( mirror://mplayer/releases/fonts/font-arial-iso-8859-1.tar.bz2
				 mirror://mplayer/releases/fonts/font-arial-iso-8859-2.tar.bz2
				 mirror://mplayer/releases/fonts/font-arial-cp1250.tar.bz2 )
	!iconv? ( mirror://mplayer/releases/fonts/font-arial-iso-8859-1.tar.bz2
			  mirror://mplayer/releases/fonts/font-arial-iso-8859-2.tar.bz2
			  mirror://mplayer/releases/fonts/font-arial-cp1250.tar.bz2 )
	gtk? ( mirror://mplayer/Skin/Blue-${BLUV}.tar.bz2 )
	svga? ( http://mplayerhq.hu/~alex/svgalib_helper-${SVGV}-mplayer.tar.bz2 )"

DESCRIPTION="Media Player for Linux"
HOMEPAGE="http://www.mplayerhq.hu/"

RDEPEND="sys-libs/ncurses
	!livecd? (
		!bindist? (
			x86? (
				win32codecs? ( media-libs/win32codecs )
				real? ( media-libs/win32codecs
					media-video/realplayer )
				)
			amd64? ( real? ( media-libs/amd64codecs ) )
		)
	)
	aalib? ( media-libs/aalib )
	alsa? ( media-libs/alsa-lib )
	amrnb? ( media-libs/amrnb )
	amrwb? ( media-libs/amrwb )
	arts? ( kde-base/arts )
	openal? ( media-libs/openal )
	bidi? ( dev-libs/fribidi )
	cdio? ( dev-libs/libcdio )
	cdparanoia? ( media-sound/cdparanoia )
	directfb? ( dev-libs/DirectFB )
	dts? ( || ( media-libs/libdca media-libs/libdts ) )
	dv? ( media-libs/libdv )
	dvb? ( media-tv/linuxtv-dvb-headers )
	encode? (
		aac? ( media-libs/faac )
		mp2? ( media-sound/twolame )
		mp3? ( media-sound/lame )
		x264? ( media-libs/x264 )
		)
	esd? ( media-sound/esound )
	enca? ( app-i18n/enca )
	gif? ( media-libs/giflib )
	ggi? ( media-libs/libggi
		media-libs/libggiwmh )
	gtk? ( media-libs/libpng
		x11-libs/libXxf86vm
		x11-libs/libXext
		x11-libs/libXi
		=x11-libs/gtk+-2* )
	jpeg? ( media-libs/jpeg )
	ladspa? ( media-libs/ladspa-sdk )
	libcaca? ( media-libs/libcaca )
	lirc? ( app-misc/lirc )
	lzo? ( >=dev-libs/lzo-2 )
	mad? ( media-libs/libmad )
	musepack? ( >=media-libs/libmpcdec-1.2.2 )
	nas? ( media-libs/nas )
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng )
	pnm? ( media-libs/netpbm )
	pulseaudio? ( media-sound/pulseaudio )
	samba? ( net-fs/samba )
	sdl? ( media-libs/libsdl )
	speex? ( >=media-libs/speex-1.1.7 )
	srt? ( >=media-libs/freetype-2.1
		media-libs/fontconfig )
	svga? ( media-libs/svgalib )
	theora? ( media-libs/libtheora )
	live? ( >=media-plugins/live-2007.02.20 )
	truetype? ( >=media-libs/freetype-2.1
		media-libs/fontconfig )
	vidix? ( x11-libs/libXxf86vm
			 x11-libs/libXext )
	xanim? ( media-video/xanim )
	xinerama? ( x11-libs/libXinerama
		x11-libs/libXxf86vm
		x11-libs/libXext )
	xv? ( x11-libs/libXv
		x11-libs/libXxf86vm
		x11-libs/libXext
		xvmc? ( x11-libs/libXvMC ) )
	xvid? ( media-libs/xvid )
	X? ( x11-libs/libXxf86vm
		x11-libs/libXext
	)"
#	video_cards_vesa? ( sys-apps/vbetool ) restrict on x86 first

DEPEND="${RDEPEND}
	doc? ( >=app-text/docbook-sgml-dtd-4.1.2
		app-text/docbook-xml-dtd
		>=app-text/docbook-xml-simple-dtd-1.50.0
		dev-libs/libxslt )
	dga? ( x11-proto/xf86dgaproto )
	xinerama? ( x11-proto/xineramaproto )
	xv? ( x11-proto/videoproto
		  x11-proto/xf86vidmodeproto )
	gtk? ( x11-proto/xextproto
		   x11-proto/xf86vidmodeproto )
	X? ( x11-proto/xextproto
		 x11-proto/xf86vidmodeproto )
	iconv? ( virtual/libiconv )"
# Make sure the assembler USE flags are unmasked on amd64
# Remove this once default-linux/amd64/2006.1 is deprecated
DEPEND="${DEPEND} amd64? ( >=sys-apps/portage-2.1.2 )
	mp2? ( >=sys-apps/portage-2.1.2 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc64 ~sparc ~x86 ~x86-fbsd"

pkg_setup() {

	if [[ -n ${LINGUAS} ]]; then
		elog "For MPlayer's language support, the configuration will"
		elog "use your LINGUAS variable from /etc/make.conf.  If you have more"
		elog "than one language enabled, then the first one in the list will"
		elog "be used to output the messages, if a translation is available."
		elog "man pages will be created for all languages where translations"
		elog "are also available."
	fi

}

src_unpack() {

	unpack ${A}

	if ! use truetype ; then
		unpack font-arial-iso-8859-1.tar.bz2 \
			font-arial-iso-8859-2.tar.bz2 \
			font-arial-cp1250.tar.bz2
	fi

	use gtk && unpack Blue-${BLUV}.tar.bz2

	use svga && unpack svgalib_helper-${SVGV}-mplayer.tar.bz2

	cd "${S}"

	# Fix hppa compilation
	use hppa && sed -i -e "s/-O4/-O1/" "${S}/configure"

	if use svga; then
		echo
		einfo "Enabling vidix non-root mode."
		einfo "(You need a proper svgalib_helper.o module for your kernel"
		einfo "to actually use this)"
		echo

		mv "${WORKDIR}/svgalib_helper" "${S}/libdha"
	fi

	# Fix polish spelling errors
	[[ -n ${LINGUAS} ]] && sed -e 's:Zarządano:Zażądano:' -i help/help_mp-pl.h

	# Pulseaudio patch, bug 203430
	epatch "${FILESDIR}/${P}-pulse.patch"
}

src_compile() {

	local myconf=" --disable-tv-bsdbt848 \
		--disable-faad-external"

	# broken upstream, won't work with recent kernels
	myconf="${myconf} --disable-ivtv --disable-pvr"

	# MPlayer reads in the LINGUAS variable from make.conf, and sets
	# the languages accordingly.  Some will have to be altered to match
	# upstream's naming scheme.
	[[ -n $LINGUAS ]] && LINGUAS=${LINGUAS/da/dk}

	################
	#Optional features#
	###############
	use bidi || myconf="${myconf} --disable-fribidi"
	use bl && myconf="${myconf} --enable-bl"
	use enca || myconf="${myconf} --disable-enca"
	use ftp || myconf="${myconf} --disable-ftp"
	use nemesi || myconf="${myconf} --disable-nemesi"
	use tivo || myconf="${myconf} --disable-vstream"

	# libcdio support: prefer libcdio over cdparanoia
	# don't check for cddb w/cdio
	if use cdio; then
		myconf="${myconf} --disable-cdparanoia"
	else
		myconf="${myconf} --disable-libcdio"
		use cdparanoia || myconf="${myconf} --disable-cdparanoia"
		use cddb || myconf="${myconf} --disable-cddb"
	fi

	# DVD support
	# dvdread and libdvdcss are internal libs
	# http://www.mplayerhq.hu/DOCS/HTML/en/dvd.html
	# You can optionally use external dvdread support, but against
	# upstream's suggestion.  We don't.
	if ! use dvd; then
		myconf="${myconf} --disable-dvdnav --disable-dvdread"
		use a52 || myconf="${myconf} --disable-liba52"
	fi

	if use encode; then
		use aac || myconf="${myconf} --disable-faac"
		use dv || myconf="${myconf} --disable-libdv"
		use x264 || myconf="${myconf} --disable-x264"
	else
		myconf="${myconf} --disable-mencoder --disable-libdv --disable-x264 \
			--disable-faac"
	fi

	# SRT (subtitles) requires freetype support
	# freetype support requires iconv
	# iconv optionally can use unicode
	if ! use srt; then
		myconf="${myconf} --disable-ass"
		if ! use truetype; then
			myconf="${myconf} --disable-freetype"
			if ! use iconv; then
				myconf="${myconf} --disable-iconv --charset=noconv"
			fi
		fi
	fi
	use iconv && use unicode && myconf="${myconf} --charset=UTF-8"

	use lirc || myconf="${myconf} --disable-lirc --disable-lircc"
	myconf="${myconf} $(use_enable joystick)"
	use ipv6 || myconf="${myconf} --disable-inet6"
	use rar || myconf="${myconf} --disable-unrarlib"
	use rtc || myconf="${myconf} --disable-rtc"
	use samba || myconf="${myconf} --disable-smb"

	# DVB / Video4Linux / Radio support
	if { use dvb || use v4l || use v4l2 || use radio; }; then
		use dvb || myconf="${myconf} --disable-dvb --disable-dvbhead"
		use v4l	|| myconf="${myconf} --disable-tv-v4l1"
		use v4l2 || myconf="${myconf} --disable-tv-v4l2"
		use teletext || myconf="${myconf} --disable-tv-teletext"
		if use radio && { use dvb || use v4l || use v4l2; }; then
			myconf="${myconf} --enable-radio $(use_enable encode radio-capture)"
		else
			myconf="${myconf} --disable-radio-v4l2 --disable-radio-bsdbt848"
		fi
	else
		myconf="${myconf} --disable-tv --disable-tv-v4l1 --disable-tv-v4l2 \
			--disable-radio --disable-radio-v4l2 --disable-radio-bsdbt848 \
			--disable-dvb --disable-dvbhead --disable-tv-teletext"
	fi

	#########
	# Codecs #
	########
	for x in gif jpeg live mad musepack pnm speex tga theora xanim xvid; do
		use ${x} || myconf="${myconf} --disable-${x}"
	done
	use aac || myconf="${myconf} --disable-faad-internal"
	use amrnb || myconf="${myconf} --disable-libamr_nb"
	use amrwb || myconf="${myconf} --disable-libamr_wb"
	use dts || myconf="${myconf} --disable-libdca"
	! use png && ! use gtk && myconf="${myconf} --disable-png"
	use lzo || myconf="${myconf} --disable-liblzo"
	use encode && use mp2 || myconf="${myconf} --disable-twolame \
		--disable-toolame"
	use mp3 || myconf="${myconf} --disable-mp3lib"
	use quicktime || myconf="${myconf} --disable-qtx"
	use vorbis || myconf="${myconf} --disable-libvorbis"
	use xanim && myconf="${myconf} --xanimcodecsdir=/usr/lib/xanim/mods"
	if use x86 || use amd64; then
		# Real codec support, only available on x86, amd64
		if use real && use x86; then
			myconf="${myconf} --realcodecsdir=/opt/RealPlayer/codecs"
		elif use real && use amd64; then
			myconf="${myconf} --realcodecsdir=/usr/$(get_libdir)/codecs"
		else
			myconf="${myconf} --disable-real"
		fi
		if ! use livecd && ! use bindist && ! use real; then
			myconf="${myconf} $(use_enable win32codecs win32dll)"
		fi
	fi

	#############
	# Video Output #
	#############
	for x in directfb ggi md5sum sdl xinerama; do
		use ${x} || myconf="${myconf} --disable-${x}"
	done
	use aalib || myconf="${myconf} --disable-aa"
	use dga || myconf="${myconf} --disable-dga1 --disable-dga2"
	use fbcon || myconf="${myconf} --disable-fbdev"
	use fbcon && use video_cards_s3virge && myconf="${myconf} --enable-s3fb"
	use libcaca || myconf="${myconf} --disable-caca"
	use opengl || myconf="${myconf} --disable-gl"
	use video_cards_vesa || myconf="${myconf} --disable-vesa"
	use vidix || myconf="${myconf} --disable-vidix-internal \
		--disable-vidix-external"
	use zoran || myconf="${myconf} --disable-zr"

	# GTK gmplayer gui
	myconf="${myconf} $(use_enable gtk gui)"

	if use xv; then
		if use xvmc; then
			myconf="${myconf} --enable-xvmc --with-xvmclib=XvMCW"
		else
			myconf="${myconf} --disable-xvmc"
		fi
	else
		myconf="${myconf} --disable-xv --disable-xvmc"
	fi

	if ! use kernel_linux && ! use video_cards_mga; then
		 myconf="${myconf} --disable-mga --disable-xmga"
	fi

	if use video_cards_tdfx; then
		myconf="${myconf} $(use_enable video_cards_tdfx tdfxvid) \
			$(use_enable fbcon tdfxfb)"
	else
		myconf="${myconf} --disable-3dfx --disable-tdfxvid --disable-tdfxfb"
	fi

	#############
	# Audio Output #
	#############
	for x in alsa arts esd jack ladspa nas openal; do
		use ${x} || myconf="${myconf} --disable-${x}"
	done
	use pulseaudio || myconf="${myconf} --disable-pulse"
	if ! use radio; then
		use oss || myconf="${myconf} --disable-ossaudio"
	fi
	#################
	# Advanced Options #
	#################
	# Platform specific flags, hardcoded on amd64 (see below)
	if use x86 || use amd64 || use ppc; then
		if use cpudetection || use livecd || use bindist; then
			myconf="${myconf} --enable-runtime-cpudetection"
		fi
	fi
	if use mmx; then
		for x in 3dnow 3dnowext mmxext sse sse2 ssse3; do
			use ${x} || myconf="${myconf} --disable-${x}"
		done
	else
		myconf="${myconf} --disable-mmx --disable-mmxext --disable-sse \
		--disable-sse2 --disable-ssse3 --disable-3dnow \
		--disable-3dnowext"
	fi

	use debug && myconf="${myconf} --enable-debug=3"

	myconf="${myconf} $(use_enable altivec)"

	if use custom-cflags; then
		# let's play the filtration game!  MPlayer hates on all!
		strip-flags
		# ugly optimizations cause MPlayer to cry on x86 systems!
			if use x86 || use x86-fbsd ; then
				replace-flags -O* -O2
				filter-flags -fPIC -fPIE

				# debug broken in this release
				# use debug || append-flags -fomit-frame-pointer
				append-flags -fomit-frame-pointer
			fi
		append-flags -D__STDC_LIMIT_MACROS
	else
		unset CFLAGS CXXFLAGS
	fi

	myconf="--cc=$(tc-getCC) \
		--host-cc=$(tc-getBUILD_CC) \
		--prefix=/usr \
		--confdir=/etc/mplayer \
		--datadir=/usr/share/mplayer \
		--libdir=/usr/$(get_libdir) \
		--enable-largefiles \
		--enable-menu \
		--enable-network \
		${myconf}"
	#echo "CFLAGS=\"${CFLAGS}\" ./configure ${myconf}"
	CFLAGS="${CFLAGS}" ./configure ${myconf} || die "configure died"

	emake || die "Failed to build MPlayer!"
	use doc && make -C DOCS/xml html-chunked
}

src_install() {

	make prefix="${D}/usr" \
		 BINDIR="${D}/usr/bin" \
		 LIBDIR="${D}/usr/$(get_libdir)" \
		 CONFDIR="${D}/etc/mplayer" \
		 DATADIR="${D}/usr/share/mplayer" \
		 MANDIR="${D}/usr/share/man" \
		 install || die "Failed to install MPlayer!"

	dodoc AUTHORS Changelog README
	# Install the documentation; DOCS is all mixed up not just html
	if use doc ; then
		find "${S}/DOCS" -type d | xargs -- chmod 0755
		find "${S}/DOCS" -type f | xargs -- chmod 0644
		cp -r "${S}/DOCS" "${D}/usr/share/doc/${PF}/" || die "cp docs died"
	fi

	# Copy misc tools to documentation path, as they're not installed directly
	# and yes, we are nuking the +x bit.
	find "${S}/TOOLS" -type d | xargs -- chmod 0755
	find "${S}/TOOLS" -type f | xargs -- chmod 0644
	cp -r "${S}/TOOLS" "${D}/usr/share/doc/${PF}/" || die "cp docs died"

	# Install the default Skin and Gnome menu entry
	if use gtk; then
		dodir /usr/share/mplayer/skins
		cp -r "${WORKDIR}/Blue" \
			"${D}/usr/share/mplayer/skins/default" || die "cp skins died"

		# Fix the symlink
		rm -rf "${D}/usr/bin/gmplayer"
		dosym mplayer /usr/bin/gmplayer
	fi

	if ! use srt && ! use truetype; then
		dodir /usr/share/mplayer/fonts
		local x=
		# Do this generic, as the mplayer people like to change the structure
		# of their zips ...
		for x in $(find "${WORKDIR}/" -type d -name 'font-arial-*')
		do
			cp -pPR "${x}" "${D}/usr/share/mplayer/fonts"
		done
		# Fix the font symlink ...
		rm -rf "${D}/usr/share/mplayer/font"
		dosym fonts/font-arial-14-iso-8859-1 /usr/share/mplayer/font
	fi

	insinto /etc/mplayer
	newins "${S}/etc/example.conf" mplayer.conf

	if use srt || use truetype;	then
		cat >> "${D}/etc/mplayer/mplayer.conf" << EOT
fontconfig=1
subfont-osd-scale=4
subfont-text-scale=3
EOT
	fi

	dosym ../../../etc/mplayer/mplayer.conf /usr/share/mplayer/mplayer.conf

	dobin "${D}/usr/share/doc/${PF}/TOOLS/midentify"

	insinto /usr/share/mplayer
	doins "${S}/etc/input.conf"
	doins "${S}/etc/menu.conf"
}

pkg_preinst() {

	if [[ -d ${ROOT}/usr/share/mplayer/Skin/default ]]
	then
		rm -rf "${ROOT}/usr/share/mplayer/Skin/default"
	fi
}

pkg_postrm() {

	# Cleanup stale symlinks
	if [ -L "${ROOT}/usr/share/mplayer/font" -a \
		 ! -e "${ROOT}/usr/share/mplayer/font" ]
	then
		rm -f "${ROOT}/usr/share/mplayer/font"
	fi

	if [ -L "${ROOT}/usr/share/mplayer/subfont.ttf" -a \
		 ! -e "${ROOT}/usr/share/mplayer/subfont.ttf" ]
	then
		rm -f "${ROOT}/usr/share/mplayer/subfont.ttf"
	fi
}
