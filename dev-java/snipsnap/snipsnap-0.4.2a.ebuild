# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/snipsnap/snipsnap-0.4.2a.ebuild,v 1.5 2004/06/24 22:42:49 agriffis Exp $

DESCRIPTION="A blog/wiki personal content management system"
HOMEPAGE="http://snipsnap.org"
SRC_URI="mirror://sourceforge/${PN}/${P}-20030326.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=">=virtual/jre-1.3"

src_install() {
	dodir /opt/${PN}
	cp -pR * ${D}/opt/${PN}

	exeinto /opt/${PN}
	newexe ${FILESDIR}/${PV}-run.sh run.sh
	exeinto /etc/init.d
	newexe ${FILESDIR}/${PV}-snipsnap snipsnap
}
