# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/py2play/py2play-0.1.2.ebuild,v 1.8 2005/02/09 23:34:53 kloeri Exp $

inherit distutils

MY_P=${P/py2play/Py2Play}
IUSE=""
DESCRIPTION="A Peer To Peer network game engine"
SRC_URI="http://oomadness.tuxfamily.org/downloads/${MY_P}.tar.gz
	http://www.nectroom.homelinux.net/pkg/${MY_P}.tar.gz
	http://nectroom.homelinux.net/pkg/${MY_P}.tar.gz"

HOMEPAGE="http://oomadness.tuxfamily.org/en/py2play/"
KEYWORDS="x86"
SLOT="0"
LICENSE="GPL-2"
DEPEND=">=dev-lang/python-2.2.2"

S=${WORKDIR}/${MY_P}

src_install() {
	distutils_src_install
	mv ${D}/usr/bin/startdemo* ${D}/usr/share/doc/${PF}/
}

