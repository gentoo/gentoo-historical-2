# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/cel-cvs/cel-cvs-0.97.ebuild,v 1.2 2003/07/13 04:56:46 vapier Exp $

inherit games cvs
ECVS_SERVER="cvs.cel.sourceforge.net:/cvsroot/cel"
ECVS_MODULE="cel"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/${PN}"
S=${WORKDIR}/${ECVS_MODULE}

HOMEPAGE="http://cel.sourceforge.net/"
SRC_URI="mirror://gentoo/distfiles/${P}.tar.gz"
DESCRIPTION="A game entity layer based on Crystal Space"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="dev-games/crystalspace
	>=sys-apps/sed-4
	dev-util/jam
	!dev-games/cel-cvs"

CEL_PREFIX=${GAMES_PREFIX_OPT}/crystal

src_compile() {
	./autogen.sh || die
	PATH="${CEL_PREFIX}/bin:${PATH}" ./configure --prefix=${CEL_PREFIX} || die
	jam || die
}

src_install() {
	sed -i -e "s:/usr/local/cel:${CEL_PREFIX}:g" cel.cex

	insinto ${CEL_PREFIX}
	doins `find include -iname '*.h'`

	into ${CEL_PREFIX}
	dolib.so *.so

	dogamesbin cel.cex
	mv celtst ${D}/${CEL_PREFIX}/

	prepgamesdirs
}
