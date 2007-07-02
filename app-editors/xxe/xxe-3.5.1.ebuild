# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/xxe/xxe-3.5.1.ebuild,v 1.4 2007/07/02 13:46:05 peper Exp $

MY_PV="${PV//./_}"

DESCRIPTION="The XMLmind XML Editor"
SRC_URI="http://www.xmlmind.net/xmleditor/_download/${PN}-std-${MY_PV}.tar.gz"
HOMEPAGE="http://www.xmlmind.com/xmleditor/index.html"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="doc"

RESTRICT="strip"

DEPEND=""
RDEPEND=">=virtual/jre-1.4.1"

S="${WORKDIR}/${PN}-std-${MY_PV}"
INSTALLDIR="/opt/${PN}"

src_install() {
	dodir "${INSTALLDIR}"
	dirs="bin addon demo"
	use doc && dirs="${dirs} doc"
	for d in $dirs; do
		cp -pPR "${S}/${d}" "${D}/${INSTALLDIR}"
	done

	chmod -x "${D}/${INSTALLDIR}"/bin/*.bat
	chmod -x "${D}/${INSTALLDIR}"/bin/*.exe
	chmod -x "${D}/${INSTALLDIR}"/bin/mac/{mkapp,JavaApplicationStub}

	echo -e "PATH=${INSTALLDIR}/bin\nROOTPATH=${INSTALLDIR}" > "${T}/10xxe"
	doenvd "${T}/10xxe"

	insinto /usr/share/applications
	doins "${FILESDIR}/xxe.desktop"
}

pkg_postinst() {
	elog "XXE has been installed in /opt/xxe, to include this"
	elog "in your path, run the following:"
	elog "    /usr/sbin/env-update && source /etc/profile"
	echo
	ewarn "If you need special/accented characters, you'll need to export LANG"
	ewarn "to your locale.  Example: export LANG=es_ES.ISO8859-1"
	ewarn "See http://www.xmlmind.com/xmleditor/user_faq.html#linuxlocale"
}
