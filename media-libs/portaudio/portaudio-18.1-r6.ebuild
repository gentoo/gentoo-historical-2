# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/portaudio/portaudio-18.1-r6.ebuild,v 1.2 2007/02/23 21:56:26 gmsoft Exp $

inherit toolchain-funcs

MY_P=${PN}_v${PV/./_}
DESCRIPTION="An open-source cross platform audio API."
HOMEPAGE="http://www.portaudio.com"
SRC_URI="http://www.portaudio.com/archives/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="18"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~sh ~sparc ~x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/unzip"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}

	if use userland_Darwin ; then
		cp "${FILESDIR}"/${P}-Makefile.macos "${S}"/Makefile
	else
		cp "${FILESDIR}"/${PF}-Makefile "${S}"/Makefile
	fi
	# Fix deprecated includes
	fgrep --null -lr malloc.h "${S}" | xargs -0 sed -i 's/malloc.h/stdlib.h/'
	fgrep --null -lr machine/soundcard.h "${S}" | xargs -0 sed -i 's/machine\/soundcard.h/sys\/soundcard.h/'
}

src_compile() {
	emake CC="$(tc-getCC)" AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" LD="$(tc-getLD)" CFLAGS="${CFLAGS}" || die
}

src_install() {
	make DESTDIR="${D}" libdir="/usr/$(get_libdir)" install || die
	fperms 644 /usr/include/portaudio/portaudio.h
	dodoc docs/*
}
