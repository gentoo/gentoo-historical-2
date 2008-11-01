# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/ispell-de/ispell-de-20071211.ebuild,v 1.1 2008/11/01 09:06:26 pva Exp $

MY_P=igerman98-${PV}
DESCRIPTION="German and Swiss dictionaries for ispell"
HOMEPAGE="http://j3e.de/ispell/igerman98/"
SRC_URI="http://j3e.de/ispell/igerman98/dict/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
IUSE=""
KEYWORDS="~ppc ~x86 ~sparc ~alpha ~mips ~hppa ~amd64"

DEPEND="app-text/ispell"

S=${WORKDIR}/${MY_P}

src_compile() {
	for lang in de_DE de_AT de_CH; do
		make ispell/${lang}{.aff,.hash}
	done
}

src_install () {
	insinto /usr/lib/ispell
	for lang in de_DE de_AT de_CH; do
		doins ispell/${lang}{.aff,.hash} || die
	done

	dodoc Documentation/*
}
