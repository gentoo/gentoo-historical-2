# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/ooextras/ooextras-20031206.ebuild,v 1.4 2005/01/21 17:40:15 suka Exp $

DESCRIPTION="OOExtras: Extra Templates for OpenOffice.org!"
HOMEPAGE="http://ooextras.sourceforge.net/"
SRC_URI="mirror://sourceforge/ooextras/${PN}${PV}.tgz"

INSTDIR="/opt/${PN}"
S="${WORKDIR}/downloads"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ~amd64 ~ppc ~sparc"
IUSE=""
DEPEND=""

src_compile() {
	true # nothing to do
}

src_install() {
	dodir ${INSTDIR}
	cp -R -- ${S}/. ${D}/${INSTDIR}/
}

pkg_postinst() {
	einfo "Please add ${INSTDIR} to your template paths in OpenOffice.org"
	einfo "You can do this under:"
	einfo "Tools > Options > OpenOffice.org > Paths"
}
