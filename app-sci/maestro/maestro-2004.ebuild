# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/maestro/maestro-2004.ebuild,v 1.5 2004/07/13 20:40:04 agriffis Exp $

DESCRIPTION="Maestro is a public release software package that NASA scientists use to operate the Spirit and Opportunity Rovers."
SRC_URI="http://freecache.org/http://mars9.telascience.org:81/softwaredownload/Maestro-Linux.tar.gz"
HOMEPAGE="http://mars.telascience.org/"
IUSE=""
DEPEND=""
RDEPEND=">=virtual/jre-1.4"
LICENSE="maestro"
SLOT="0"
KEYWORDS="~x86"

S=${WORKDIR}/R2004_02-Public-Linux

src_unpack() {
	unpack ${A}
	cd ${S}/JPL/SAP/WITS-db
	einfo "Unpacking default data sets..."
	tar xf mer.tar
	rm mer.tar
	cd ${S}
}

src_install () {
	dodir /opt/${PN}
	cp -r JPL/ ${D}/opt/${PN}
	echo "#!/bin/sh" >> ${PN}
	echo "cd /opt/${PN}/JPL/SAP/bin" >> ${PN}
	echo "./SAP" >> ${PN}
	into /opt
	dobin ${PN}
}

pkg_postinst() {
	einfo
	einfo "Dataset updates can be found online at:"
	einfo "     http://mars.telascience.org/update"
	einfo
	einfo "To run maestro, simply type: maestro"
	einfo
}
