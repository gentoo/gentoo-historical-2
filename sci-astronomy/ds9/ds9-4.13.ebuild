# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/ds9/ds9-4.13.ebuild,v 1.4 2007/08/17 09:54:01 bicatali Exp $

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
	x11-libs/libXau"
DEPEND="${RDEPEND}
	|| ( virtual/emacs virtual/xemacs )
	app-arch/zip"

RESTRICT="strip test"

S=${WORKDIR}/sao${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# patch to speed up compilation (no man pages generation)
	epatch "${FILESDIR}"/${P}-Makefile.patch
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
	emake -j1 OPTS="${CXXFLAGS}" || die "emake failed"
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
