# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Martin Schlemmer <azarah@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-video/mplayer/mplayer-0.60-r5.ebuild,v 1.5 2002/04/16 09:44:01 seemant Exp $

# Handle PREversions as well
MY_PV=${PV/_/}
S="${WORKDIR}/MPlayer-${MY_PV}"
# Only install Skin if GUI should be build (gtk as USE flag)
SRC_URI="ftp://mplayerhq.hu/MPlayer/releases/MPlayer-${MY_PV}.tar.bz2
	 ftp://mplayerhq.hu/MPlayer/releases/mp-arial-iso-8859-1.zip
	 ftp://ftp.mplayerhq.hu/MPlayer/patches/dxr3.patch
	 gtk? ( http://www.ibiblio.org/gentoo/distfiles/default-skin-0.1.tar.bz2 )"
#	 This is to get the digest problem fixed.
#	 gtk? ( ftp://mplayerhq.hu/MPlayer/Skin/default.tar.bz2 )"
DESCRIPTION="Media Player for Linux"
HOMEPAGE="http://www.mplayerhq.hu/"

# 'encode' in USE for MEncoder
RDEPEND="media-libs/divx4linux
	>=media-libs/win32codecs-${PV}
	dvd? ( media-libs/libdvdread
	       media-libs/libdvdcss )
	gtk? ( >=x11-libs/gtk+-1.2.10-r4
	       media-libs/libpng )
	esd? ( media-sound/esound )
	ggi? ( media-libs/libggi )
	sdl? ( media-libs/libsdl )
	alsa? ( media-libs/alsa-lib )
	svga? ( media-libs/svgalib )
	encode? ( media-sound/lame )
	opengl? ( virtual/opengl )
	oggvorbis? ( media-libs/libvorbis )"

DEPEND="${RDEPEND}
	dev-lang/nasm
	app-arch/unzip"


src_unpack() {

	unpack MPlayer-${MY_PV}.tar.bz2 mp-arial-iso-8859-1.zip

	# Fix bug with the default Skin
	use gtk && ( \
		unpack default-skin-0.1.tar.bz2
		cd ${WORKDIR}/default
		patch < ${FILESDIR}/default-skin.diff || die "gtk patch failed"
	)

	use matrox && ( \
		cd ${S}/drivers;
		patch < ${FILESDIR}/mga_vid_devfs.patch || die "matrox patch failed"
	)
	
	#patch mplayer with the DXR3 patch
	local module=""
	local dxr=""
	for module in `lsmod` ; do
		if [ ${module} = "em8300" ] ; then
			dxr=true
		fi
	done
	if [ $dxr ] ; then
		cd ${WORKDIR};
		mv ${S} ${S}a
		patch -p0 < ${DISTDIR}/dxr3.patch || die "dxr3 patch failed"
		mv ${S}a ${S}
	fi
}

src_compile() {

	local myconf=""

	use 3dnow \
		|| myconf="${myconf} --disable-3dnow --disable-3dnowex"

	use sse	\
		|| myconf="${myconf} --disable-sse --disable-sse2"

	# Only disable MMX if 3DNOW or SSE is not in USE
	use mmx || use 3dnow || use sse \
		|| myconf="${myconf} --disable-mmx --disable-mmx2"

	# Only disable X if gtk is not in USE
	use X || use gtk \
		|| myconf="${myconf} --disable-x11 --disable-xv --disable-xmga"

	use matrox && use X \
		&& myconf="${myconf} --enable-xmga"

	use gtk \
		&& myconf="${myconf} --enable-gui --enable-x11 --enable-xv"

	use oss \
		|| myconf="${myconf} --disable-ossaudio"

	use opengl \
		|| myconf="${myconf} --disable-gl"

	use sdl \
		|| myconf="${myconf} --disable-sdl"

	use ggi \
		|| myconf="${myconf} --disable-ggi"

	use svga \
		|| myconf="${myconf} --disable-svga"

	use fbcon \
		&& myconf="${myconf} --enable-fbdev"

	use alsa \
		|| myconf="${myconf} --disable-alsa"

	use oggvorbis \
		|| myconf="${myconf} --disable-vorbis"

	use encode \
		&& myconf="${myconf} --enable-mencoder --enable-tv" \
		|| myconf="${myconf} --disable-mencoder"

	use dvd \
		&& myconf="${myconf} --enable-dvdread --enable-css"

	use matrox \
		&& myconf="${myconf} --enable-mga"

	use 3dfx \
		&& myconf="${myconf} --enable-3dfx --enable-tdfxfb"

	# Crashes on start when compiled with most optimizations.
	# The code have CPU detection code now, with CPU specific
	# optimizations, so extra should not be needed and is not
	# recommended by the authors
	CFLAGS="" \
	CXXFLAGS="" \
	./configure --prefix=/usr \
		${myconf} || die

	emake all || die
	
	use matrox && ( \
		cd drivers \
		emake all || die
	)
}

src_install() {

	make prefix=${D}/usr/share \
	     BINDIR=${D}/usr/bin \
	     CONFDIR=${D}/usr/share/mplayer \
	     DATADIR=${D}/usr/share/mplayer \
	     MANDIR=${D}/usr/share/man \
	     install || die
	
	# MAN pages are already installed ...
	rm DOCS/*.1
	# Install the rest of the documentation
	dodir /usr/share/doc/${PF}
	cp -a DOCS/* ${D}/usr/share/doc/${PF}
	doalldocs

	# Install the default Skin and Gnome menu entry
	use gtk && ( \
		insinto /usr/share/mplayer/Skin/default
		doins ${WORKDIR}/default/*
		# Permissions is fried by default
		chmod a+rx ${D}/usr/share/mplayer/Skin/default/
		chmod a+r ${D}/usr/share/mplayer/Skin/default/*

		# Fix the symlink
		rm -rf ${D}/usr/bin/gmplayer
		dosym /usr/bin/mplayer /usr/bin/gmplayer
	)

	use gnome && ( \
		insinto /usr/share/pixmaps
		newins ${S}/Gui/mplayer/pixmaps/icon.xpm mplayer.xpm
		insinto /usr/share/gnome/apps/Multimedia
		doins ${FILESDIR}/mplayer.desktop
	)

	# Install the font used by OSD and the GUI
	dodir /usr/share/mplayer/fonts
	cp -a ${WORKDIR}/iso-8859-1/ ${D}/usr/share/mplayer/fonts
	rm -rf ${D}/usr/share/mplayer/font
	dosym /usr/share/mplayer/fonts/iso-8859-1/arial-14/ /usr/share/mplayer/font

	# This tries setting up mplayer.conf automagically
	local video="sdl" audio="sdl"
	use X && (
		use gtk && video="xv" \
		|| use sdl && video="sdl" \
		|| use xv && video="xv" \
		|| use opengl && video="gl" \
		|| use ggi && video="ggi" \
		|| use dga && video="dga" \
		|| video="x11"
	) || (
		use directfb && video="fbdev" \
		|| use svga && video="svga" \
		|| use aalib && video="aa"
	)

	use sdl && audio="sdl" \
	|| use alsa && audio="alsa5" \
	|| use oss audio="oss" \
	
	# Note to myself:  do not change " into '
	sed -e "s/vo=xv/vo=${video}/"					\
	    -e "s/ao=oss/ao=${audio}/"					\
	    -e 's/include =/#include =/'				\
	    ${S}/etc/example.conf > ${T}/mplayer.conf

	insinto /etc
	doins ${T}/mplayer.conf 
	
	insinto /usr/share/mplayer
	doins ${S}/etc/codecs.conf

	use matrox && ( \
		dodir /lib/modules/${KVERS}/kernel/drivers/char
		cp ${S}/drivers/mga_vid.o ${D}/lib/modules/${KVERS}/kernel/drivers/char
	)
}

pkg_postinst() {

	echo
	echo '######################################################################'
	echo '# MPlayer users that are going to use the GUI, please note the       #'
	echo '# following:                                                         #'
	echo '#                                                                    #'
	echo '#   The GUI works best with mplayer -vo xv -gui, but since there is  #'
	echo '#   no USE flag for XVideo, or for using the GUI, the autodetection  #'
	echo '#   process cannot detect this by default (SDL will be used rather). #'
	echo '#   So, if your setup supports XVideo (xvinfo should give output),   #'
	echo '#   maybe do something like:                                         #'
	echo '#                                                                    #'
	echo '#     echo "vo = xv" >~/.mplayer/config                              #'
	echo '#     echo "gui = 1" >>~/.mplayer/config                             #'
	echo '#                                                                    #'
	echo '#   after launching mplayer for the first time.                      #'
	echo '#                                                                    #'
	use gtk &>/dev/null \
		|| echo '# NB: the GUI needs "gtk" as USE flag to build.                      #'
	echo '######################################################################'
	echo
	depmod -a
}
