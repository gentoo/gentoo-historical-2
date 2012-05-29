# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/csound/csound-5.17.6.ebuild,v 1.3 2012/05/29 11:00:58 radhermit Exp $

EAPI="4"
PYTHON_DEPEND="python? 2"

inherit eutils multilib python java-pkg-opt-2 cmake-utils toolchain-funcs versionator

MY_PN="${PN/c/C}"
MY_P="${MY_PN}${PV}"

DESCRIPTION="A sound design and signal processing system providing facilities for composition and performance"
HOMEPAGE="http://csounds.com/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa beats chua csoundac +cxx debug double-precision dssi examples fltk +fluidsynth
+image jack java keyboard linear lua luajit nls osc openmp portaudio portmidi pulseaudio
python samples static-libs stk tcl test +threads +utils vim-syntax vst"

LANGS=" de en_GB en_US es_CO fr it ro ru"
IUSE+="${LANGS// / linguas_}"

RDEPEND=">=media-libs/libsndfile-1.0.16
	alsa? ( media-libs/alsa-lib )
	csoundac? ( x11-libs/fltk:1[threads?]
		dev-libs/boost
		=dev-lang/python-2* )
	dssi? ( media-libs/dssi
		media-libs/ladspa-sdk )
	fluidsynth? ( media-sound/fluidsynth )
	fltk? ( x11-libs/fltk:1[threads?] )
	image? ( media-libs/libpng )
	jack? ( media-sound/jack-audio-connection-kit )
	java? ( >=virtual/jdk-1.5 )
	keyboard? ( x11-libs/fltk:1[threads?] )
	linear? ( sci-mathematics/gmm )
	lua? (
		luajit? ( dev-lang/luajit:2 )
		!luajit? ( dev-lang/lua )
	)
	osc? ( media-libs/liblo )
	portaudio? ( media-libs/portaudio )
	portmidi? ( media-libs/portmidi )
	pulseaudio? ( media-sound/pulseaudio )
	stk? ( media-libs/stk )
	tcl? ( >=dev-lang/tcl-8.5
		>=dev-lang/tk-8.5 )
	utils? ( !media-sound/snd )
	vst? ( x11-libs/fltk:1[threads?]
		dev-libs/boost
		=dev-lang/python-2* )"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/yacc
	chua? ( dev-libs/boost )
	csoundac? ( dev-lang/swig )
	nls? ( sys-devel/gettext )
	test? ( =dev-lang/python-2* )
	vst? ( dev-lang/swig )"

REQUIRED_USE="vst? ( csoundac )
	java? ( cxx )
	linear? ( double-precision )
	lua? ( cxx )
	python? ( cxx )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi

	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-5.16.6-tests.patch
	epatch "${FILESDIR}"/${P}-fltk.patch
	epatch "${FILESDIR}"/${P}-porttime-in-portmidi.patch

	sed -i -e "s:^\(csoundExecutable =\).*:\1 \"${WORKDIR}/${P}_build/csound\":" \
		tests/test.py || die

	sed -i -e '/set(PLUGIN_INSTALL_DIR/s/-${APIVERSION}//' CMakeLists.txt || die

	if [[ $(get_libdir) == "lib64" ]] ; then
		sed -i -e '/set(LIBRARY_INSTALL_DIR/s/lib/lib64/' CMakeLists.txt || die
	fi
}

src_configure() {
	local myconf

	if use csoundac ; then
		use python && myconf+=" -DBUILD_CSOUND_AC_PYTHON_INTERFACE=ON"
		use lua && myconf+=" -DBUILD_CSOUND_AC_LUA_INTERFACE=ON"
	fi

	local mycmakeargs=(
		-DBUILD_NEW_PARSER=ON
		$(cmake-utils_use_use alsa ALSA) \
		$(cmake-utils_use_build beats CSBEATS) \
		$(cmake-utils_use_build chua CHUA_OPCODES) \
		$(cmake-utils_use_build csoundac CSOUND_AC) \
		$(cmake-utils_use_build cxx CXX_INTERFACE) \
		$(cmake-utils_use debug NEW_PARSER_DEBUG) \
		$(cmake-utils_use_use double-precision DOUBLE) \
		$(cmake-utils_use_build dssi DSSI_OPCODES) \
		$(cmake-utils_use_build fluidsynth FLUID_OPCODES) \
		$(cmake-utils_use_use fltk FLTK) \
		$(cmake-utils_use_build image IMAGE_OPCODES) \
		$(cmake-utils_use_use jack JACK) \
		$(cmake-utils_use_build jack JACK_OPCODES) \
		$(cmake-utils_use_build java JAVA_INTERFACE) \
		$(cmake-utils_use_build keyboard VIRTUAL_KEYBOARD) \
		$(cmake-utils_use_build linear LINEAR_ALGEBRA_OPCODES) \
		$(cmake-utils_use_build lua LUA_OPCODES) \
		$(cmake-utils_use_build lua LUA_INTERFACE) \
		$(cmake-utils_use_use nls GETTEXT) \
		$(cmake-utils_use_build osc OSC_OPCODES) \
		$(cmake-utils_use_use openmp OPEN_MP) \
		$(cmake-utils_use_use portaudio PORTAUDIO) \
		$(cmake-utils_use_use portmidi PORTMIDI) \
		$(cmake-utils_use_use pulseaudio PULSEAUDIO) \
		$(cmake-utils_use_build python PYTHON_OPCODES) \
		$(cmake-utils_use_build python PYTHON_INTERFACE) \
		$(cmake-utils_use_build static-libs STATIC_LIBRARY) \
		$(cmake-utils_use_build stk STK_OPCODES) \
		$(cmake-utils_use_build tcl TCLCSOUND) \
		$(cmake-utils_use_build threads MULTI_CORE) \
		$(cmake-utils_use_build utils UTILITIES) \
		${myconf}
	)

	cmake-utils_src_configure
}

src_test() {
	export LD_LIBRARY_PATH="${S}" OPCODEDIR="${S}" OPCODEDIR64="${S}"
	cd tests
	./test.py || die "tests failed"
}

src_install() {
	cmake-utils_src_install

	dodoc AUTHORS ChangeLog readme-csound5-complete.txt

	# Generate env.d file
	if use double-precision ; then
		echo OPCODEDIR64=/usr/$(get_libdir)/${PN}/plugins64 > "${T}"/62${PN}
	else
		echo OPCODEDIR=/usr/$(get_libdir)/${PN}/plugins > "${T}"/62${PN}
	fi
	echo "CSSTRNGS=/usr/share/locale" >> "${T}"/62${PN}
	use stk && echo "RAWWAVE_PATH=/usr/share/csound/rawwaves" >> "${T}"/62${PN}
	doenvd "${T}"/62${PN}

	if use examples ; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	use samples && dodoc -r samples

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax
		doins installer/misc/vim/csound_{csd,orc,sco}.vim
		insinto /usr/share/vim/vimfiles/plugin
		doins installer/misc/vim/csound.vim
	fi
}
