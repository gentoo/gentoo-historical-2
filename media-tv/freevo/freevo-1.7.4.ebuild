# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/freevo/freevo-1.7.4.ebuild,v 1.1 2007/12/01 21:04:50 rbu Exp $

inherit distutils

DESCRIPTION="Digital video jukebox (PVR, DVR)."
HOMEPAGE="http://www.freevo.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

IUSE="dvd lirc matrox minimal mixer nls sqlite tv X directfb fbcon doc"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"

RDEPEND=">=dev-python/pygame-1.5.6
	>=dev-python/pyxml-0.8.2
	>=dev-python/imaging-1.1.3
	>=dev-python/twisted-2.4
	>=dev-python/twisted-web-0.6
	>=media-video/mplayer-0.92
	>=media-libs/freetype-2.1.4
	>=media-libs/libsdl-1.2.5
	>=sys-apps/sed-4
	>=dev-python/elementtree-1.2.6
	>=dev-python/beautifulsoup-3.0
	>=dev-python/kaa-base-0.1.3
	>=dev-python/kaa-metadata-0.6.1
	>=dev-python/kaa-imlib2-0.2.1
	dvd? ( >=media-video/xine-ui-0.9.22 >=media-video/lsdvd-0.10 )
	tv? ( media-tv/tvtime !minimal? ( media-tv/xmltv ) )
	mixer? ( media-sound/aumix )
	matrox? ( >=media-video/matroxset-0.3 )
	lirc? ( app-misc/lirc >=dev-python/pylirc-0.0.3 )
	sqlite? ( ~dev-python/pysqlite-1.0.1 )"

pkg_setup() {
	if use directfb ; then
		use dvd && ! (built_with_use media-libs/xine-lib directfb) \
			&& ewarn "media-libs/xine-lib was not built with directfb support"
		! (built_with_use media-video/mplayer directfb) \
			&& ewarn "media-video/mplayer was not built with directfb support"
		if ! (built_with_use media-libs/libsdl directfb) ; then
			eerror "media-libs/libsdl was not built with directdb support"
			eerror "Please re-emerge libsdl with the directfb use flag"
			die "directfb use flag specified but no support in libsdl and others"
		fi
	fi

	if use fbcon ; then
		use dvd && ! (built_with_use media-libs/xine-lib fbcon) \
			&& ewarn "media-libs/xine-lib was not built with fbcon support"
		! (built_with_use media-video/mplayer fbcon) \
			&& ewarn "media-video/mplayer was not built with fbcon support"
		if ! (built_with_use media-libs/libsdl fbcon) ; then
			eerror "media-libs/libsdl was not built with fbcon support"
			eerror "Please re-emerge libsdl with the fbcon use flag"
			die "fbcon use flag specified but no support in media-libs/libsdl and others"
		fi
	fi

	if ! (use X || use directfb || use fbcon || use matrox) ; then
		echo
		ewarn "WARNING - no video support specified in USE flags."
		ewarn "Please be sure that media-libs/libsdl supports whatever video"
		ewarn "support (X11, fbcon, directfb, etc) you plan on using."
		echo
	fi

	if ! (     (built_with_use  media-libs/sdl-image jpeg) \
		&& (built_with_use  media-libs/sdl-image png ) ) ; then
		eerror "media-libs/sdl-image needs more image format support (USE=\"png jpeg\")"
		die "re-emerge media-libs/sdl-image with the given USE flags"
	fi
}

src_install() {
	distutils_src_install

	insinto /etc/freevo
	newins local_conf.py.example local_conf.py

	if [ "${PROFILE_ARCH}" == "xbox" ]; then
		sed -i -e "s/# MPLAYER_AO_DEV.*/MPLAYER_AO_DEV='alsa1x'/" "${D}"/etc/freevo/local_conf.py
		newins "${FILESDIR}"/xbox-lircrc lircrc
	fi

	if use X; then
		echo "#!/bin/bash" > freevo
		echo "/usr/bin/freevoboot startx" >> freevo
		exeinto /etc/X11/Sessions/
		doexe freevo

		#insinto /etc/X11/dm/Sessions
		#doins "${FILESDIR}/freevo.desktop"

		insinto /usr/share/xsessions
		doins "${FILESDIR}/freevo.desktop"
	fi

	exeinto /usr/bin
	newexe "${FILESDIR}/freevo.boot" freevoboot
	newconfd "${FILESDIR}/freevo.conf" freevo

	rm -rf "${D}/usr/share/doc"

	dodoc ChangeLog FAQ INSTALL PKG-INFO README TODO \
		Docs/{CREDITS,NOTES,*.txt,plugins/*.txt}
	use doc &&
		cp -r Docs/{installation,html,plugin_writing} "${D}/usr/share/doc/${PF}"

	use nls || rm -rf "${D}"/usr/share/locale

	# Create a default freevo setup
	cd "${S}/src"
	if [ "${PROFILE_ARCH}" == "xbox" ]; then
		myconf="${myconf} --geometry=640x480 --display=x11"
	elif use matrox && use directfb; then
		myconf="${myconf} --geometry=768x576 --display=dfbmga"
	elif use matrox ; then
		myconf="${myconf} --geometry=768x576 --display=mga"
	elif use directfb; then
		myconf="${myconf} --geometry=768x576 --display=directfb"
	elif use X ; then
		myconf="${myconf} --geometry=800x600 --display=x11"
	else
		myconf="${myconf} --geometry=800x600 --display=fbdev"
	fi
	sed -i "s:/etc/freevo/freevo.conf:${D}/etc/freevo/freevo.conf:g" setup_freevo.py || die "Could not fix setup_freevo.py"
	python setup_freevo.py ${myconf} || die "Could not create new freevo.conf"
}

pkg_postinst() {
	echo
	einfo "Please check /etc/freevo/freevo.conf and"
	einfo "/etc/freevo/local_conf.py before starting Freevo."
	einfo "To rebuild freevo.conf with different parameters,"
	einfo "please run:"
	einfo "  # freevo setup"

	einfo "To update your local configuration, please run"
	einfo "  # freevo convert_config /etc/freevo/local_conf.py -w"

	echo
	einfo "To build a freevo-only system, please use the freevoboot"
	einfo "wrapper to be run it as a user. It can be configured in /etc/conf.d/freevo"
	if use X ; then
		echo
		ewarn "If you're using a Freevo-only system with X, you'll need"
		ewarn "to setup the autologin (as user) and choose freevo as"
		ewarn "default session. If you need to run recordserver/webserver"
		ewarn "at boot, please use /etc/conf.d/freevo"
		echo
		ewarn "Should you decide to personalize your freevo.desktop"
		ewarn "session, keep the definition for '/usr/bin/freevoboot starx'"
	else
		echo
		ewarn "If you want Freevo to start automatically,you'll need"
		ewarn "to follow instructions at :"
		ewarn "http://freevo.sourceforge.net/cgi-bin/doc/BootFreevo"
		echo
		ewarn "*NOTE: you can use mingetty or provide a login"
		ewarn "program for getty to autologin as a user with limited privileges."
		ewarn "A tutorial for getty is at:"
		ewarn "http://ubuntuforums.org/showthread.php?t=152274"
	fi

	if [ -e "${ROOT}/etc/init.d/freevo" ] ; then
		echo
		ewarn "Please remove /etc/init.d/freevo as it is a security"
		ewarn "threat. To set autostart read above."
	fi

	if [ -e "${ROOT}/opt/freevo" ] ; then
		echo
		ewarn "Please remove ${ROOT}/opt/freevo because it is no longer used."
	fi
	if [ -e "${ROOT}/etc/freevo/freevo_config.py" ] ; then
		echo
		ewarn "Please remove ${ROOT}/etc/freevo/freevo_config.py."
	fi
	if [ -e "${ROOT}/etc/init.d/freevo-record" ] ; then
		echo
		ewarn "Please remove ${ROOT}/etc/init.d/freevo-record"
	fi
	if [ -e "${ROOT}/etc/init.d/freevo-web" ] ; then
		echo
		ewarn "Please remove ${ROOT}/etc/init.d/freevo-web"
	fi
}
