# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/mythtv/mythtv-0.20_p12288-r1.ebuild,v 1.1 2006/12/20 20:04:49 cardoe Exp $

inherit mythtv flag-o-matic multilib eutils debug qt3

DESCRIPTION="Homebrew PVR project"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE_VIDEO_CARDS="video_cards_i810 video_cards_nvidia video_cards_via"

IUSE="alsa altivec autostart backendonly crciprec debug dbox2 dts dvb dvd freebox frontendonly hdhomerun ieee1394 ivtv jack joystick lcd lirc mmx vorbis opengl perl xvmc ${IUSE_VIDEO_CARDS}"

RDEPEND=">=media-libs/freetype-2.0
	>=media-sound/lame-3.93.1
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXv
	x11-libs/libXrandr
	x11-libs/libXxf86vm
	xvmc? (
		x11-libs/libXvMC
		video_cards_nvidia? ( || ( x11-drivers/nvidia-drivers
								 x11-drivers/nvidia-legacy-drivers ) )
		video_cards_via? ( x11-drivers/xf86-video-via )
		video_cards_i810? ( x11-drivers/xf86-video-i810 )
	)
	$(qt_min_version 3.3)
	virtual/mysql
	alsa? ( >=media-libs/alsa-lib-0.9 )
	dts? ( media-libs/libdts )
	dvd? ( 	media-libs/libdvdnav
		media-libs/libdts )
	dvb? ( media-libs/libdvb media-tv/linuxtv-dvb-headers )
	ivtv? ( media-tv/ivtv )
	jack? ( media-sound/jack-audio-connection-kit )
	lcd? ( app-misc/lcdproc )
	lirc? ( app-misc/lirc )
	vorbis? ( media-libs/libvorbis )
	opengl? ( virtual/opengl )
	ieee1394? (	>=sys-libs/libraw1394-1.2.0
			>=sys-libs/libavc1394-0.5.0
			>=media-libs/libiec61883-1.0.0 )
	|| ( >=net-misc/wget-1.9.1 >=media-tv/xmltv-0.5.34 )
	autostart? ( net-dialup/mingetty
				x11-wm/evilwm
				x11-apps/xset )"

DEPEND="${RDEPEND}
	x11-apps/xinit"

PDEPEND="=x11-themes/mythtv-themes-${MY_PV}*"

S="${WORKDIR}/${PN}-${MY_PV}"

MYTHTV_GROUPS="video,audio,tty"

pkg_setup() {

	local rip=0
	if ! built_with_use -a =x11-libs/qt-3* mysql opengl ; then
		echo
		eerror "MythTV requires Qt to be built with mysql and opengl use flags enabled."
		eerror "Please re-emerge =x11-libs/qt-3*, after having the use flags set."
		echo
		rip=1
	fi

	if use xvmc && use video_cards_nvidia; then
		echo
		ewarn "You enabled the 'xvmc' USE flag, you must have a GeForce 4 or"
		ewarn "greater to use this. Otherwise, you'll have crashes with MythTV"
		echo
	fi

	if use xvmc && ! ( use video_cards_i810 || use video_cards_nvidia || use video_cards_via ); then
		echo
		eerror "You enabled the XvMC USE flag but did not configure VIDEO_CARDS with either"
		eerror "an nVidia, Intel i810, or VIA video card."
		echo
		rip=1
	fi

	if use autostart && use backendonly; then
		echo
		eerror "You can't have USE=autostart while having USE=backendonly."
		eerror "USE=autostart is for mythfrontend"
		echo
		rip=1
	fi

	[[ $rip == 1 ]] && die "Please fix the above issues, before continuing."

	echo
	einfo "This ebuild now uses a heavily stripped down version of your CFLAGS"
	einfo "Don't complain because your -momfg-fast-speed CFLAG is being stripped"
	einfo "Only additional CFLAG issues that will be addressed are for binary"
	einfo "package building."
	echo
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	#Fixes of the bugs found in the release
	mythtv-fixes_patch

	# As needed fix since they don't know how to write qmake let alone a real
	# make system
	epatch "${FILESDIR}"/${PN}-${MY_PV}-as-needed.patch
}

src_compile() {
	local myconf="--prefix=/usr
		--mandir=/usr/share/man
		--libdir-name=$(get_libdir)"
	use alsa || myconf="${myconf} --disable-audio-alsa"
	use jack || myconf="${myconf} --disable-audio-jack"
	use dts || myconf="${myconf} --disable-dts"
	use freebox || myconf="${myconf} --disable-freebox"
	use dbox2 || myconf="${myconf} --disable-dbox2"
	use hdhomerun || myconf="${myconf} --disable-hdhomerun"
	use crciprec || myconf="${myconf} --disable-crciprec"
	use altivec || myconf="${myconf} --disable-altivec"
	use xvmc && myconf="${myconf} --enable-xvmc"
	use xvmc && use video_cards_via && myconf="${myconf} --enable-xvmc-pro"
	use perl && myconf="${myconf} --with-bindings=perl"
	myconf="${myconf}
		--disable-audio-arts
		$(use_enable lirc)
		$(use_enable joystick joystick-menu)
		$(use_enable dvb)
		--dvb-path=/usr/include
		$(use_enable opengl opengl-vsync)
		$(use_enable ieee1394 firewire)
		--enable-xrandr
		--enable-xv
		--disable-directfb
		--enable-x11
		--enable-proc-opt"

	if use mmx || use amd64; then
		myconf="${myconf} --enable-mmx"
	else
		myconf="${myconf} --disable-mmx"
	fi

	if use debug; then
		myconf="${myconf} --compile-type=debug"
	else
		myconf="${myconf} --compile-type=release"
	fi

	## CFLAG cleaning so it compiles
	MARCH=$(get-flag "march")
	MTUNE=$(get-flag "mtune")
	MCPU=$(get-flag "mcpu")
	strip-flags
	filter-flags "-march=*" "-mtune=*" "-mcpu=*"
	filter-flags "-O" "-O?"

	if [[ -n "${MARCH}" ]]; then
		myconf="${myconf} --arch=${MARCH}"
	fi
	if [[ -n "${MTUNE}" ]]; then
		myconf="${myconf} --tune=${MTUNE}"
	fi
	if [[ -n "${MCPU}" ]]; then
		myconf="${myconf} --cpu=${MCPU}"
	fi

#	myconf="${myconf} --extra-cxxflags=\"${CXXFLAGS}\" --extra-cflags=\"${CFLAGS}\""
	hasq distcc ${FEATURES} || myconf="${myconf} --disable-distcc"
	hasq ccache ${FEATURES} || myconf="${myconf} --disable-ccache"

	if use frontendonly; then
		##Backend Removal
		ewarn
		ewarn "You are using the experimental feature for only installing the frontend."
		ewarn "You will not get Gentoo support nor support from MythTV upstream for this."
		ewarn "If this breaks, you own both pieces."
		ewarn
		myconf="${myconf} --disable-backend"
	fi

	if use backendonly; then
		##Frontend Removal
		ewarn
		ewarn "You are using the experimental feature for only installing the backend."
		ewarn "You will not get Gentoo support nor support from MythTV upstream for this."
		ewarn "If this breaks, you own both pieces."
		ewarn
		myconf="${myconf} --disable-frontend"
	fi

	# let MythTV come up with our CFLAGS. Upstream will support this
	CFLAGS=""
	CXXFLAGS=""
	einfo "Running ./configure ${myconf}"
	./configure ${myconf} || die "configure died"

	${QTDIR}/bin/qmake QMAKE=${QTDIR}/bin/qmake -o "Makefile" mythtv.pro || die "qmake failed"
	emake || die "emake failed"

}

src_install() {

	einstall INSTALL_ROOT="${D}" || die "install failed"
	for doc in AUTHORS FAQ UPGRADING ChangeLog README; do
		test -e "${doc}" && dodoc ${doc}
	done

	if ! use frontendonly; then
		insinto /usr/share/mythtv/database
		doins database/*

		exeinto /usr/share/mythtv
		doexe "${FILESDIR}/mythfilldatabase.cron"

		newinitd ${FILESDIR}/mythbackend-0.18.2.rc mythbackend
		newconfd ${FILESDIR}/mythbackend-0.18.2.conf mythbackend
	fi


	dodoc keys.txt docs/*.{txt,pdf}
	dohtml docs/*.html

	keepdir /etc/mythtv
	chown -R mythtv "${D}"/etc/mythtv
	keepdir /var/log/mythtv
	chown -R mythtv "${D}"/var/log/mythtv

	insinto /usr/share/mythtv/contrib
	doins contrib/*

	insinto /usr/share/mythtv/configfiles
	doins configfiles/*

	if ! use backendonly; then
		dobin "${FILESDIR}"/runmythfe

		if use autostart; then
			dodir /etc/env.d/
			echo 'CONFIG_PROTECT="/home/mythtv/"' > ${D}/etc/env.d/95mythtv

			insinto /home/mythtv
			newins "${FILESDIR}"/bash_profile .bash_profile
			newins "${FILESDIR}"/xinitrc .xinitrc
		fi
	fi
}

pkg_preinst() {
	enewuser mythtv -1 /bin/bash /home/mythtv ${MYTHTV_GROUPS} || die "Problem adding mythtv user"
	usermod -a -G ${MYTHTV_GROUPS} mythtv

	export CONFIG_PROTECT="${CONFIG_PROTECT} ${ROOT}/home/mythtv/"
}

pkg_postinst() {
	if ! use backendonly; then
		echo
		elog "Want mythfrontend to start automatically?"
		elog "Set USE=autostart. Details can be found at:"
		elog "http://dev.gentoo.org/~cardoe/mythtv/autostart.html"
	fi

	if ! use frontendonly; then
		echo
		elog "To always have MythBackend running and available run the following:"
		elog "rc-update add mythbackend default"
		echo
		ewarn "Your recordings folder must be owned by the user 'mythtv' now"
		ewarn "chown -R mythtv /path/to/store"
	fi

	if use autostart; then
		echo
		elog "Please add the following to your /etc/inittab file at the end of"
		elog "the TERMINALS section"
		elog "c8:2345:respawn:/sbin/mingetty --autologin mythtv tty8"
	fi

}

