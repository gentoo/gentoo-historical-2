# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/gato/gato-0.98i.ebuild,v 1.1 2004/12/27 21:11:53 ribosome Exp $

DESCRIPTION="Graph Animation Toolbox"
HOMEPAGE="http://www.zpr.uni-koeln.de/~gato/"
SRC_URI="http://www.zpr.uni-koeln.de/~gato/Download/Gato-0.98I.tar"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/python
	dev-lang/tk"

S=${WORKDIR}/Gato

src_install() {

	insinto /usr/lib/${PN}
	doins *.py
	fperms 755 /usr/lib/${PN}/Gato.py /usr/lib/${PN}/Gred.py

	dodir /usr/bin
	dosym /usr/lib/${PN}/Gato.py /usr/bin/gato
	dosym /usr/lib/${PN}/Gred.py /usr/bin/gred

	insinto /usr/share/${PN}
	doins BFS.* DFS.* sample.cat
}
