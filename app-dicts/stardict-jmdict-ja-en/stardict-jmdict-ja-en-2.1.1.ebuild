# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/stardict-jmdict-ja-en/stardict-jmdict-ja-en-2.1.1.ebuild,v 1.3 2004/05/31 18:24:58 vapier Exp $

FROM_LANG="Japanese"
TO_LANG="English"
DICT_PREFIX="jmdict-"

inherit stardict

SRC_URI="http://www-lce.eng.cam.ac.uk/~acnt2/code/${P}.tar"

LICENSE="GDLS"

S=${WORKDIR}

src_install() {
	stardict_src_install
	dodoc README
}
