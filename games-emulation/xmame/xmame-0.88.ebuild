# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/xmame/xmame-0.88.ebuild,v 1.3 2004/11/30 20:54:06 swegener Exp $

inherit flag-o-matic gcc eutils games

TARGET="${PN}"

DESCRIPTION="Multiple Arcade Machine Emulator for X11"
HOMEPAGE="http://x.mame.net/"
SRC_URI="http://x.mame.net/download/xmame-${PV}.tar.bz2"

LICENSE="xmame"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE="3dfx alsa arts dga esd ggi joystick net opengl sdl svga X xv"

RDEPEND="sys-libs/zlib
	sdl? ( >=media-libs/libsdl-1.2.0 )
	alsa? ( media-libs/alsa-lib )
	xv? ( virtual/x11 )
	dga? ( virtual/x11 )
	X? ( virtual/x11 )
	opengl? (
		virtual/x11
		virtual/opengl
		virtual/glu )
	expat? ( dev-libs/expat )
	esd? ( >=media-sound/esound-0.2.29 )
	svga? ( media-libs/svgalib )
	ggi? ( media-libs/libggi )
	arts? ( kde-base/arts )"
DEPEND="${RDEPEND}
	x86? ( dev-lang/nasm )
	>=sys-apps/sed-4"
# Icc sucks. bug #41342
#	icc? ( dev-lang/icc )

S="${WORKDIR}/xmame-${PV}"

toggle_feature() {
	if use $1 ; then
		sed -i \
			-e "/$2.*=/s:#::" Makefile \
			|| die "sed Makefile ($1 / $2) failed"
	fi
}
toggle_feature2() {
	use $1 && toggle_feature $2 $3
}

src_unpack() {
	local mycpu=

	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PV}-glx-fix.patch"

	case ${ARCH} in
		x86)	mycpu="i386";;
		ia64)	mycpu="ia64";;
		amd64)	mycpu="amd64";;
		ppc)	mycpu="risc";;
		sparc)	mycpu="risc";;
		hppa)	mycpu="risc";;
		alpha)	mycpu="alpha";;
		mips)	mycpu="mips";;
	esac

	sed -i \
		-e '/^BUILD_EXPAT/s/^/#/' \
		-e "/^PREFIX/s:=.*:=/usr:" \
		-e "/^MY_CPU/s:i386:${mycpu}:" \
		-e "/^BINDIR/s:=.*:=${GAMES_BINDIR}:" \
		-e "/^MANDIR/s:=.*:=/usr/share/man/man6:" \
		-e "/^XMAMEROOT/s:=.*:=${GAMES_DATADIR}/${TARGET}:" \
		-e "/^TARGET/s:mame:${TARGET:1}:" \
		-e "s:^CFLAGS =:CFLAGS=${CFLAGS}:" \
		Makefile \
		|| die "sed Makefile failed"

	if use ppc ; then
		sed -i \
			-e '/LD.*--relax/s:^# ::' Makefile \
			|| die "sed Makefile (ppc/LD) failed"
	fi


	#toggle_feature x86 X86_ASM_68020 # Broken
	toggle_feature x86 X86_ASM_68000
	toggle_feature x86 X86_MIPS3_DRC
	toggle_feature2 x86 mmx EFFECT_MMX_ASM
	toggle_feature joystick JOY_STANDARD
	use net && ewarn "Network support is currently (${PV}) broken :("
	#toggle_feature net XMAME_NET # Broken
	toggle_feature esd SOUND_ESOUND
	toggle_feature alsa SOUND_ALSA
	toggle_feature arts SOUND_ARTS
	toggle_feature dga X11_DGA
	toggle_feature xv X11_XV
	toggle_feature expat BUILD_EXPAT
	toggle_feature opengl X11_OPENGL

	case ${ARCH} in
		x86|ia64|amd64)
			append-flags -Wno-unused -fomit-frame-pointer -fstrict-aliasing -fstrength-reduce
			use amd64 || append-flags -ffast-math #54270
			[ $(gcc-major-version) -eq 3 ] \
				&& append-flags -falign-functions=2 -falign-jumps=2 -falign-loops=2 \
				|| append-flags -malign-functions=2 -malign-jumps=2 -malign-loops=2
			;;
		ppc)
			append-flags -Wno-unused -funroll-loops -fstrength-reduce -fomit-frame-pointer -ffast-math -fsigned-char
			;;
		hppa)
			append-flags -ffunction-sections
			;;
	esac

	sed -i \
		-e "s:[Xx]mame:${TARGET}:g" \
		doc/*.6 \
		|| die "sed man pages failed"
	sed -i \
		-e '/^QUIET/s:^:#:' src/unix/unix.mak \
		|| die "sed src/unix/unix.mak failed"
}

src_compile() {
	local disp=0
	if use sdl ; then
		emake DISPLAY_METHOD=SDL || die "emake failed (SDL)"
		disp=1
	fi
	if use svga ; then
		emake DISPLAY_METHOD=svgalib || die "emake failed (svgalib)"
		disp=1
	fi
	if use ggi ; then
		#emake DISPLAY_METHOD=ggi || die "emake failed (ggi)"
		#disp=1
		ewarn "GGI support is currently (${PV}) broken :("
	fi
	if  [ ${disp} -eq 0 ] || use opengl || use X || use dga || use xv ; then
		emake DISPLAY_METHOD=x11 || die "emake failed (x11)"
	fi
}

src_install() {
	local disp=0

	sed -i \
		-e "s:^PREFIX.*:PREFIX=${D}/usr:" \
		-e "s:^BINDIR.*:BINDIR=${D}/${GAMES_BINDIR}:" \
		-e "s:^MANDIR.*:MANDIR=${D}/usr/share/man/man6:" \
		-e "s:^XMAMEROOT.*:XMAMEROOT=${D}/${GAMES_DATADIR}/${TARGET}:" \
		Makefile \
		|| die "sed Makefile failed"

	if use sdl ; then
		make DISPLAY_METHOD=SDL install || die "install failed (sdl)"
		disp=1
	fi
	if use svga ; then
		make DISPLAY_METHOD=svgalib install || die "install failed (svga)"
		disp=1
	fi
	if use ggi ; then
		#make DISPLAY_METHOD=ggi install || die "install failed (ggi)"
		#disp=1
		ewarn "GGI support is currently (${PV}) broken :("
	fi
	if [ ${disp} -eq 0 ] || use opengl || use X || use dga || use xv ; then
		make DISPLAY_METHOD=x11 install || die "install failed (x11)"
	fi
	exeinto "${GAMES_LIBDIR}/${PN}"
	doexe chdman xml2info || die "doexe failed"

	dodir "${GAMES_DATADIR}/${PN}"
	cp -r ctrlr "${D}/${GAMES_DATADIR}/${PN}/" || die "cp failed"
	dodoc doc/{changes.*,*.txt,mame/*,${TARGET}rc.dist} README todo \
		|| die "dodoc failed"
	dohtml -r doc/* || die "dohtml failed"

	if [ ${disp} -eq 0 ] || use opengl || use X || use dga || use xv ; then
		dosym "${TARGET}.x11" "${GAMES_BINDIR}/${TARGET}"
	elif use sdl ; then
		dosym "${TARGET}.SDL" "${GAMES_BINDIR}/${TARGET}"
	elif use svga ; then
		dosym ${TARGET}.svgalib "${GAMES_BINDIR}/${TARGET}"
	#elif use ggi ; then
		#dosym ${TARGET}.ggi "${GAMES_BINDIR}/${TARGET}"
	fi
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	einfo "Your available MAME binaries are: ${TARGET}"
	if useq opengl || useq X || useq dga || useq xv ; then
		einfo " ${TARGET}.x11"
	fi
	useq sdl    && einfo " ${TARGET}.SDL"
	#useq ggi    && einfo " ${TARGET}.ggi"
	useq svga   && einfo " ${TARGET}.svgalib"
}
