# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/waif/waif-0.59.7.ebuild,v 1.12 2004/10/07 03:31:20 eradicator Exp $

IUSE="xmms oggvorbis"

S=${WORKDIR}/${PN}
S2=${WORKDIR}/wfxmms
DESCRIPTION="Why Another Infernal Frontend -- console front end for various media-players"
HOMEPAGE="http://eds.org/~straycat"
SRC_URI="http://www.eds.org/~straycat/${P}.tar.gz
	xmms? http://www.eds.org/~straycat/wfxmms-0.6.tgz"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~ppc x86 sparc amd64"

DEPEND="dev-lang/tcl
	dev-tcltk/expect"

RDEPEND="dev-tcltk/expect
	virtual/mpg123
	media-sound/takcd
	media-sound/aumix
	media-libs/id3lib
	media-sound/id3v2
	media-sound/id3ed
	xmms? ( media-sound/xmms )
	oggvorbis? ( media-sound/vorbis-tools )"


src_compile() {
	cd Waif
	./mkindex.sh || die

	if use xmms
	then
		cd ${S2}
		make || die
	fi
}

src_install() {

	local tclv
	tclv=$(grep TCL_VER /usr/include/tcl.h | sed 's:^.*"\(.*\)".*:\1:')

	cd ${S}
	insinto /usr/$(get_libdir)/tcl${tclv}/Waif
	doins Waif/*

	into /usr
	dobin waif-helper waifsh
	doman waifsh.1

	dodoc CHANGES FAQ INSTALL README* TODO WHATSNEW
	dodoc ${FILESDIR}/LICENSE
	docinto Documentation
	dodoc Documentation/*

	if use xmms
	then
		cd ${S2}
		into /usr
		dobin wfxmms

		docinto wfxmms
		dodoc BUGS CHANGES README
	fi
}
