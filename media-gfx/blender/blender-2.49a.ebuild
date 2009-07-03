# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/blender/blender-2.49a.ebuild,v 1.2 2009/07/03 00:43:28 mr_bones_ Exp $

EAPI=2

inherit multilib eutils python

IUSE="blender-game ffmpeg nls ogg openmp verse openal"

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="http://www.blender.org/"
SRC_URI="http://download.blender.org/source/${P}.tar.gz"

SLOT="0"
LICENSE="|| ( GPL-2 BL BSD )"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="ffmpeg? ( >=media-video/ffmpeg-0.5 )
	media-libs/jpeg
	media-libs/openjpeg
	media-libs/tiff
	>=dev-lang/python-2.5
	nls? ( >=media-libs/freetype-2.0
		virtual/libintl
		>=media-libs/ftgl-2.1 )
	openal? ( >=media-libs/openal-1.6.372 )
	>=media-libs/freealut-1.1.0-r1
	media-libs/openexr
	media-libs/libpng
	blender-game? ( >=media-libs/libsdl-1.2[joystick] )
	>=media-libs/libsdl-1.2
	ogg? ( media-libs/libogg )
	virtual/opengl"

DEPEND=">=dev-util/scons-0.98
	sys-devel/gcc[openmp?]
	x11-base/xorg-server
	${RDEPEND}"

blend_with() {
	local UWORD="$2"
	if [ -z "${UWORD}" ]; then
		UWORD="$1"
	fi
	if useq $1; then
		echo "WITH_BF_${UWORD}=1" | tr '[:lower:]' '[:upper:]' \
			>> "${S}"/user-config.py
	else
		echo "WITH_BF_${UWORD}=0" | tr '[:lower:]' '[:upper:]' \
			>> "${S}"/user-config.py
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/blender-2.48a-CVE-2008-4863.patch
	epatch "${FILESDIR}"/${PN}-2.37-dirs.patch
	epatch "${FILESDIR}"/${PN}-2.44-scriptsdir.patch
	epatch "${FILESDIR}"/${PN}-2.49a-sys-openjpeg.patch
	rm -f "${S}/release/scripts/bpymodules/"*.pyc
}

src_configure() {

	# add ffmpeg info to the scons build info
	cat <<- EOF >> "${S}"/user-config.py
		BF_FFMPEG="/usr"
		BF_FFMPEG_LIB="avdevice avformat avcodec swscale avutil"
	EOF

	#  set python version to current version in use
	python_version
	cat <<- EOF >> "${S}"/user-config.py
		BF_PYTHON_VERSION="${PYVER}"
		BF_PYTHON_INC="/usr/include/python${PYVER}"
		BF_PYTHON_BINARY="/usr/bin/python${PYVER}"
		BF_PYTHON_LIB="python${PYVER}"
	EOF

	# add system openjpeg into scons build.
	cat <<- EOF >> "${S}"/user-config.py
		BF_OPENJPEG = "/usr"
		BF_OPENJPEG_INC = "/usr/include"
		BF_OPENJPEG_LIB = "openjpeg"
	EOF

	#set CFLAGS used in /etc/make.conf correctly

	echo "CFLAGS= [`for i in ${CFLAGS[@]}; do printf "%s \'$i"\',; done`] " \
		  | sed -e "s:,]: ]:" >> "${S}"/user-config.py

	echo "CXXFLAGS= [`for i in ${CFLAGS[@]}; do printf "%s \'$i"\',; done`]" \
		 | sed -e "s:,]: ]:" >> "${S}"/user-config.py

	# check for blender-game USE flag.
	# blender-game will merge with blenderplayer.

	for arg in \
			'openal'\
			'ffmpeg' \
			'blender-game player' \
			'blender-game gameengine' \
			'nls international' \
			'ogg' \
			'openmp' \
			'verse' ; do
		blend_with ${arg}
	done
}

src_compile() {
	# scons uses -l differently -> remove it
	scons ${MAKEOPTS/-l[0-9]} || die \
	'!!! Please add "${S}/scons.config" when filing bugs reports \
	to bugs.gentoo.org'

	cd "${WORKDIR}"/install/linux2/plugins
	chmod 755 bmake
	emake || die
}

src_install() {
	exeinto /usr/bin/
	doexe "${WORKDIR}"/install/linux2/blender
	use blender-game && doexe "${WORKDIR}"/install/linux2/blenderplayer

	dodir /usr/share/${PN}

	exeinto /usr/$(get_libdir)/${PN}/textures
	doexe "${WORKDIR}"/install/linux2/plugins/texture/*.so
	exeinto /usr/$(get_libdir)/${PN}/sequences
	doexe "${WORKDIR}"/install/linux2/plugins/sequence/*.so
	insinto /usr/include/${PN}
	doins "${WORKDIR}"/install/linux2/plugins/include/*.h

	if use nls ; then
		mv "${WORKDIR}"/install/linux2/.blender/{.Blanguages,.bfont.ttf} \
			"${D}"/usr/share/${PN}
		mv "${WORKDIR}"/install/linux2/.blender/locale \
			"${D}"/usr/share/locale
	fi

	mv "${WORKDIR}"/install/linux2/.blender/scripts "${D}"/usr/share/${PN}

	insinto /usr/share/pixmaps
	doins "${WORKDIR}"/install/linux2/icons/scalable/blender.svg
	insinto /usr/share/applications
	doins "${FILESDIR}"/${PN}.desktop

	dodoc INSTALL README
	dodoc "${WORKDIR}"/install/linux2/BlenderQuickStart.pdf

}

pkg_preinst(){
	if [ -h "${ROOT}/usr/$(get_libdir)/blender/plugins/include" ];
	then
		rm -f "${ROOT}"/usr/$(get_libdir)/blender/plugins/include
	fi
}

pkg_postinst(){
	elog "blender uses python integration.  As such, may have some"
	elog "inherit risks with running unknown python scripting."
	elog " "
	elog "CVE-2008-1103-1.patch has been removed as it interferes"
	elog "with autosave undo features. Up stream blender coders"
	elog "have not addressed the CVE issue as the status is still"
	elog "a CANDIDATE and not CONFIRMED."
	elog " "
	elog "It is recommended to change your blender temp directory"
	elog "from /tmp to ~tmp or another tmp file under your home"
	elog "directory. This can be done by starting blender, then"
	elog "dragging the main menu down do display all paths."
}
