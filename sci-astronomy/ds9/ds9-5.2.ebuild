# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/ds9/ds9-5.2.ebuild,v 1.3 2008/11/07 14:39:08 bicatali Exp $

inherit flag-o-matic eutils

DESCRIPTION="Data visualization application for astronomical FITS images"
HOMEPAGE="http://hea-www.harvard.edu/RD/ds9"
SRC_URI="http://hea-www.harvard.edu/saord/download/${PN}/source/${PN}.${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RDEPEND="x11-libs/libX11
	x11-libs/libXdmcp
	x11-libs/libXau
	!x11-libs/xpa"
DEPEND="${RDEPEND}
	app-arch/zip"

S="${WORKDIR}/sao${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-gcc43.patch

	# patch to fix and speed up compilation (no man pages generation)
	epatch "${FILESDIR}"/${P}-Makefile.patch

	# fix stack smashing on x86 with gcc-4.2
	use x86 && epatch "${FILESDIR}"/${PN}-5.1-gcc4.2-x86.patch

	# remove build-time dependency on etags (i.e. emacs or xemacs)
	sed -i -e '/^all/s/TAGS//' saotk/*/Makefile || die "sed failed"

	# remove forced compilers and let defined ones propagate
	sed -i -e '/^CC[[:space:]]/d' -e '/^CXX[[:space:]]/d' make.*
}

src_compile() {
	local ds9arch
	case ${ARCH} in
		x86) ds9arch=linux ;;
		amd64) ds9arch=linux64 ;;
		ppc) ds9arch=linuxppc ;;
		x86-fbsd) ds9arch=freebsd ;;
		*) die "ds9 not supported upstream for this architecture";;
	esac
	ln -s make.${ds9arch} make.include

	# This is a long and fragile compilation
	# which recompiles tcl/tk, tkimg, blt, funtools,
	# and a lot of other packages
	emake -j1 OPTS="${CXXFLAGS}" \
		|| die "emake failed"
}

src_install () {
	dobin bin/ds9 || die "failed installing ds9 binary"
	dobin bin/xpa* || die "failed installing xpa* binaries"
	doman man/man?/xpa* || die " failed installing man pages"
	dodoc README acknowledgement || die "failed installing basic doc"
	if use doc; then
		dohtml -r doc/* || die "failed installing html doc"
	fi
}
