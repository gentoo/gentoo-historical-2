# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Michael Conrad Tilstra <michael@gentoo.org> <tadpol@tadpol.org>
# $Header: /var/cvsroot/gentoo-x86/app-text/dictd-jargon/dictd-jargon-4.2.3-r1.ebuild,v 1.3 2002/07/31 17:54:11 kabau Exp $

MY_P=${PN/dictd-/}_${PV}
S=${WORKDIR}
DESCRIPTION="Jargon lexicon"
SRC_URI="ftp://ftp.dict.org/pub/dict/pre/${MY_P}.tar.gz"
HOMEPAGE="http://www.dict.org"

DEPEND=">=app-text/dictd-1.5.5"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

src_install () {
	dodoc README
	dodir /usr/lib/dict
	insinto /usr/lib/dict
	doins jargon.dict.dz
	doins jargon.index
}

# vim: ai et sw=4 ts=4
