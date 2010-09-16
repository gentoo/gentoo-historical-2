# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/arb/arb-5.1-r1.ebuild,v 1.2 2010/09/16 17:21:30 scarabeus Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Tools for DNA/RNA sequence database handling and data analysis, phylogenetic analysis"
HOMEPAGE="http://www.arb-home.de/"
SRC_URI="
	http://download.arb-home.de/release/arb_${PV}/arbsrc.tgz -> ${P}.tgz
	mirror://gentoo/${P}-glibc2.10.patch.bz2
	mirror://gentoo/${P}-linker.patch.bz2"
MY_TAG=6213

LICENSE="arb"
SLOT="0"
IUSE="+opengl"
KEYWORDS="~amd64 ~x86"

DEPEND="
	app-text/sablotron
	www-client/lynx
	x11-libs/openmotif
	x11-libs/libXpm
	x11-libs/libXaw
	media-libs/tiff
	media-libs/libpng
	opengl? ( media-libs/glew
		media-libs/freeglut
		media-libs/mesa[motif] )"
RDEPEND="${DEPEND}
	sci-visualization/gnuplot"
# Recommended: libmotif3 gv xfig xterm treetool java

S="${WORKDIR}/arbsrc_${MY_TAG}"

src_prepare() {
	epatch "${WORKDIR}"/${P}-glibc2.10.patch
	epatch "${WORKDIR}"/${P}-linker.patch
	epatch "${FILESDIR}"/${PV}-libs.patch
	sed -i \
		-e 's/all: checks/all:/' \
		-e "s/GCC:=.*/GCC=$(tc-getCC) ${CFLAGS}/" \
		-e "s/GPP:=.*/GPP=$(tc-getCXX) ${CFLAGS}/" \
		"${S}/Makefile" || die
	cp config.makefile.template config.makefile
	sed -i -e '/^[ \t]*read/ d' -e 's/SHELL_ANS=0/SHELL_ANS=1/' "${S}/arb_install.sh" || die
	use amd64 && sed -i -e 's/ARB_64 := 0/ARB_64 := 1/' config.makefile
	use opengl || sed -i -e 's/OPENGL := 1/OPENGL := 0/' config.makefile
	emake ARBHOME="${S}" links || die
	# In 5.0; fixed in 5.1
	# (cd INCLUDE/GL; for i in ../../GL/glAW/*.h; do ln -s $i; done) || die
}

src_compile() {
	emake ARBHOME="${S}" PATH="${PATH}:${S}/bin" LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${S}/lib" tarfile || die
	use amd64 && mv arb.tgz arb.64.gentoo.tgz
	use x86 && mv arb.tgz arb.32.gentoo.tgz
	ln -s arb.*.tgz arb.tgz || die
}

src_install() {
	ARBHOME="${D}/opt/arb" "${S}/arb_install.sh" || die
	cat <<- EOF > "${S}/99${PN}"
	ARBHOME=/opt/arb
	PATH=/opt/arb/bin
	LD_LIBRARY_PATH=/opt/arb/lib
	EOF
	doenvd "${S}/99${PN}" || die
}
