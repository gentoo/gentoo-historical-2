# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/xxe/xxe-2.8_p1.ebuild,v 1.3 2005/01/01 13:37:39 eradicator Exp $

MY_PV="${PV/./}"
MY_PV="${MY_PV/_p/p}"
S="${WORKDIR}/${PN}-std-${MY_PV}"
DESCRIPTION="The XMLmind XML Editor"
SRC_URI="http://www.xmlmind.net/xmleditor/_download/${PN}-std-${MY_PV}.tar.gz"
HOMEPAGE="http://www.xmlmind.com/xmleditor/index.html"
IUSE=""

SLOT="0"
LICENSE="as-is"
KEYWORDS="~x86 ~ppc ~amd64"

RESTRICT="nostrip nomirror"
RDEPEND=">=virtual/jdk-1.4.1"
DEPEND=""
INSTALLDIR=/opt/${PN}

src_install() {
	dodir ${INSTALLDIR}
	cp -a ${S}/* ${D}/${INSTALLDIR}

	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}\nROOTPATH=${INSTALLDIR}" > ${D}/etc/env.d/10xxe

	insinto /usr/share/applications
	doins ${FILESDIR}/xxe.desktop
}

pkg_postinst() {
	einfo
	einfo "XXE has been installed in /opt/xxe, to include this"
	einfo "in your path, run the following:"
	eerror "    /usr/sbin/env-update && source /etc/profile"
	einfo
}
