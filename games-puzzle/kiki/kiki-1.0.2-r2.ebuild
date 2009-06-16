# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/kiki/kiki-1.0.2-r2.ebuild,v 1.4 2009/06/16 20:28:29 nyhm Exp $

EAPI=2
inherit eutils python toolchain-funcs games

DESCRIPTION="Fun 3D puzzle game using SDL/OpenGL"
HOMEPAGE="http://kiki.sourceforge.net/"
SRC_URI="mirror://sourceforge/kiki/${P}-src.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""

RDEPEND="media-libs/libsdl[opengl]
	media-libs/sdl-image
	media-libs/sdl-mixer
	dev-lang/python
	virtual/opengl
	virtual/glu
	virtual/glut"
DEPEND="${RDEPEND}
	dev-lang/swig"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc41.patch \
		"${FILESDIR}"/${P}-freeglut.patch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-build.patch
	ecvs_clean
	rm -f py/runkiki

	# Change the hard-coded data dir for sounds, etc...
	sed -i \
		-e "s:kiki_home += \"/\";:kiki_home = \"${GAMES_DATADIR}/${PN}/\";:g" \
		-e "s:KConsole\:\:printf(\"WARNING \:\: environment variable KIKI_HOME not set ...\");::g" \
		-e "s:KConsole\:\:printf(\"           ... assuming resources in current directory\");::g" \
		src/main/KikiController.cpp \
		|| die "sed KikiController.cpp failed"

	# Bug 139570
	cd SWIG
	swig -c++ -python -globals kiki -o KikiPy_wrap.cpp KikiPy.i || die
	cp -f kiki.py ../py
}

src_compile() {
	emake -C kodilib/linux AR="$(tc-getAR)" || die "emake kodilib failed"
	python_version
	emake -C linux PYTHON_VERSION="${PYVER}" || die "emake linux failed"
}

src_install() {
	dogamesbin linux/kiki || die "dogamesbin failed"

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r py sound || die "doins failed"

	dodoc Readme.txt Thanks.txt
	prepgamesdirs
}
