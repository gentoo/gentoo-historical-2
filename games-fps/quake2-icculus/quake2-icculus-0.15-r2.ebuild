# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake2-icculus/quake2-icculus-0.15-r2.ebuild,v 1.1 2004/11/27 15:46:27 wolf31o2 Exp $

inherit eutils gcc games

MY_P="quake2-r${PV}"
DESCRIPTION="The icculus.org linux port of iD's quake2 engine"
HOMEPAGE="http://icculus.org/quake2/"
SRC_URI="http://icculus.org/quake2/files/${MY_P}.tar.gz
	!noqmax? ( http://icculus.org/quake2/files/maxpak.pak )
	rogue? ( ftp://ftp.idsoftware.com/idstuff/quake2/source/roguesrc320.shar.Z )
	xatrix? ( ftp://ftp.idsoftware.com/idstuff/quake2/source/xatrixsrc320.shar.Z )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha amd64"
IUSE="arts svga sdl aalib dedicated opengl noqmax rogue xatrix"

# default to X11 if svga/opengl/sdl/aalib/dedicated are not in USE
RDEPEND="virtual/libc
	opengl? ( virtual/opengl )
	svga? ( media-libs/svgalib )
	sdl? ( media-libs/libsdl )
	aalib? ( media-libs/aalib )
	!svga? ( !opengl? ( !sdl? ( !aalib? ( !dedicated? ( virtual/x11 ) ) ) ) )
	arts? ( kde-base/arts )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	app-arch/sharutils"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if [ -e /etc/env.d/09opengl ]
	then
		# Set up X11 implementation
		X11_IMPLEM_P="$(portageq best_version "${ROOT}" virtual/x11)"
		X11_IMPLEM="${X11_IMPLEM_P%-[0-9]*}"
		X11_IMPLEM="${X11_IMPLEM##*\/}"
		einfo "X11 implementation is ${X11_IMPLEM}."

		VOID=$(cat /etc/env.d/09opengl | grep ${X11_IMPLEM})

		USING_X11=$?
		if [ "${USING_X11}" -eq "1" ]
		then
			GL_IMPLEM=$(cat /etc/env.d/09opengl | cut -f5 -d/)
			opengl-update ${X11_IMPLEM}
		fi
	else
		die "Could not find /etc/env.d/09opengl. Please run opengl-update."
	fi
}

src_unpack() {
	unpack ${MY_P}.tar.gz
	cd ${S}
	epatch "${FILESDIR}/${PV}-Makefile-noopts.patch"
	epatch "${FILESDIR}/${PV}-Makefile-optflags.patch"
	epatch "${FILESDIR}/${PV}-Makefile-amd64.patch"
	epatch "${FILESDIR}/${PV}-gentoo-path.patch"
	epatch "${FILESDIR}/${PV}-amd64.patch"
	sed -i \
		-e "s:GENTOO_DATADIR:${GAMES_DATADIR}/quake2-data:" \
		-e "s:GENTOO_LIBDIR:${GAMES_LIBDIR}/quake2-icculus:" \
		src/qcommon/files.c \
		|| die "sed src/qcommon/files.c failed"
	sed -i \
		-e "s:GENTOO_LIBDIR:${GAMES_LIBDIR}/quake2-icculus:" \
		src/linux/vid_so.c \
		|| die "sed src/linux/vid_so.c failed"

	ln -s $(which echo) ${T}/more
	for g in $(useq rogue && echo rogue) $(useq xatrix && echo xatrix); do
		mkdir -p ${S}/src/${g}
		cd ${S}/src/${g}
		unpack ${g}src320.shar.Z
		sed -i \
			-e 's:^read ans:ans=yes :' ${g}src320.shar \
			|| die "sed ${g}src320.shar failed"
		env PATH="${T}:${PATH}" unshar ${g}src320.shar
		rm ${g}src320.shar
	done
	if use rogue ; then
		sed -i \
			-e 's:<nan\.h>:<bits/nan.h>:' ${S}/src/rogue/g_local.h \
				|| die "sed g_local.h failed"
	fi
}

yesno() {
	for f in $@ ; do
		if ! useq $f ; then
			echo NO
			return 1
		fi
	done
	echo YES
	return 0
}

src_compile() {
	BUILD_X11=$(yesno X)
	use sdl || use opengl || use svga || use aalib || BUILD_X11=YES

	# xatrix fails to build
	# rogue fails to build
	for BUILD_QMAX in YES NO ; do
		use noqmax && [ "${BUILD_QMAX}" == "YES" ] && continue
		[ "${BUILD_QMAX}" == "YES" ] \
			&& echo "#define GENTOO_LIBDIR \"${GAMES_LIBDIR}/${PN}-qmax\"" > src/linux/gentoo-libdir.h \
			|| echo "#define GENTOO_LIBDIR \"${GAMES_LIBDIR}/${PN}\"" > src/linux/gentoo-libdir.h
		make clean || die "cleaning failed"
		make build_release \
			BUILD_SDLQUAKE2=$(yesno sdl) \
			BUILD_SVGA=$(yesno svga) \
			BUILD_X11=${BUILD_X11} \
			BUILD_GLX=$(yesno opengl) \
			BUILD_SDL=$(yesno sdl) \
			BUILD_SDLGL=$(yesno sdl opengl) \
			BUILD_CTFDLL=YES \
			BUILD_XATRIX=$(yesno xatrix) \
			BUILD_ROGUE=$(yesno rogue) \
			BUILD_JOYSTICK=$(yesno joystick) \
			BUILD_DEDICATED=YES \
			BUILD_AA=$(yesno aalib) \
			BUILD_QMAX=${BUILD_QMAX} \
			HAVE_IPV6=NO \
			BUILD_ARTS=NO \
			SDLDIR=/usr/lib \
			BUILD_ARTS=$(yesno arts) \
			OPTCFLAGS="${CFLAGS}" \
			|| die "make failed"
			#HAVE_IPV6=$(yesno ipv6) \
		# now we save the build dir ... except for the object files ...
		rm release*/*/*.o
		mv release* my-rel-${BUILD_QMAX}
		cd my-rel-${BUILD_QMAX}
		rm -rf ref_{gl,soft} ded game client ctf/*.o
		mkdir baseq2
		mv game*.so baseq2/
		cd ..
	done
}

src_install() {
	local q2dir=${GAMES_LIBDIR}/${PN}
	local q2maxdir=${GAMES_LIBDIR}/${PN}-qmax

	dodoc readme.txt README TODO ${FILESDIR}/README-postinstall

	# regular q2 files
	dodir ${q2dir}
	cp -rf my-rel-NO/* ${D}/${q2dir}/
	dogamesbin ${D}/${q2dir}/{quake2,q2ded}
	rm ${D}/${q2dir}/{quake2,q2ded}
	use sdl && dogamesbin ${D}/${q2dir}/sdlquake2 && rm ${D}/${q2dir}/sdlquake2

	# q2max files
	if ! use noqmax ; then
		dodir ${q2maxdir}
		cp -rf my-rel-YES/* ${D}/${q2maxdir}/
		newgamesbin ${D}/${q2maxdir}/quake2 quake2-qmax
		newgamesbin ${D}/${q2maxdir}/q2ded q2ded-qmax
		rm ${D}/${q2maxdir}/{quake2,q2ded}
		use sdl && newgamesbin ${D}/${q2maxdir}/sdlquake2 sdlquake2-qmax && rm ${D}/${q2maxdir}/sdlquake2

		insinto ${q2maxdir}/baseq2
		doins ${DISTDIR}/maxpak.pak
	fi
	prepgamesdirs
}

pkg_postinst() {
	if [ "${USING_X11}" -eq "1" ]
	then
		opengl-update ${GL_IMPLEM}
	fi
	games_pkg_postinst
	einfo "Go read /usr/share/doc/${PF}/README-postinstall.gz right now!"
	einfo "It's important- This install is just the engine, you still need"
	einfo "the data paks. Go read."
}
