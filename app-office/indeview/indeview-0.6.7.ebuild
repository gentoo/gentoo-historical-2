# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/indeview/indeview-0.6.7.ebuild,v 1.1 2009/03/01 12:03:25 patrick Exp $

DESCRIPTION="Convert OpenOffice/KOffice to run independently on Linux, OSX, or Windows"
HOMEPAGE="http://www.indeview.org/"
SRC_URI="http://www.${PN}.org/download/${P}.tgz"
LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="=x11-libs/qt-3*"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}/Viewer

src_compile() {
	${QTDIR}/bin/qmake || die "qmake failed"
	make || die "make failed"

	# Fix up the OpenOffice macro file
	cd "${S}"/../Creator/OpenOffice/
	cp IndeViewExport.bas IndeViewExport.mo.bas
	sed -i -e 's:unknown:/usr/share/IndeView/ROOT_DATA:' IndeViewExport.mo.bas
	# Convert special characters to &XXX; style
	sed -i -e 's/&/\&amp;/g' IndeViewExport.mo.bas
	sed -i -e 's/"/\&quot;/g' IndeViewExport.mo.bas
	sed -i -e 's/</\&lt;/g' IndeViewExport.mo.bas
	sed -i -e 's/>/\&gt;/g' IndeViewExport.mo.bas
	sed -i -e "s/'/\&apos;/g" IndeViewExport.mo.bas

	cat >> IndeViewExport.xba << _EOF_
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE script:module PUBLIC "-//OpenOffice.org//DTD OfficeDocument 1.0//EN" "module.dtd">
<script:module xmlns:script="http://openoffice.org/2000/script" script:name="IndeViewExport" script:language="StarBasic">
_EOF_
	cat IndeViewExport.mo.bas >> IndeViewExport.xba
	cat >> IndeViewExport.xba << _EOF_
</script:module>
_EOF_

	cd "${S}"/../Creator/KPresenter
	sed -i -e 's:^ROOT_DATA=unknown:ROOT_DATA=/usr/share/IndeView/ROOT_DATA:' kpr2iv.sh
}

src_install() {
	dobin bin/indeview
	dobin ../Creator/KPresenter/kpr2iv.sh

	cd "${S}"/..
	dohtml -r doc/html/*
	dodoc README AUTHORS

	dodir /usr/share/IndeView
	cp -pPR "${S}"/../ROOT_DATA "${D}"/usr/share/IndeView/

	if [ -e /opt/OpenOffice.org ]; then
		dodir /opt/OpenOffice.org/share/basic/Tools
		insinto /opt/OpenOffice.org/share/basic/Tools
		cd "${S}"/../Creator/OpenOffice/
		doins IndeViewExport.xba
	else
		dodir /usr/lib/openoffice/share/basic/Tools
		insinto /usr/lib/openoffice/share/basic/Tools
		cd "${S}"/../Creator/OpenOffice/
		doins IndeViewExport.xba
	fi
}

pkg_postinst() {
	# Add script to OpenOffice macros list
	if [ -e /opt/OpenOffice.org ];
	then
		grep "IndeViewExport" /opt/OpenOffice.org/share/basic/Tools/script.xlb > /dev/null 2>&1 ||
			sed -i -e 's;</library:library>; <library:element library:name="IndeViewExport"/>\n</library:library>;' /opt/OpenOffice.org/share/basic/Tools/script.xlb
	else
		grep "IndeViewExport" /usr/lib/openoffice/share/basic/Tools/script.xlb > /dev/null 2>&1 ||
			sed -i -e 's;</library:library>; <library:element library:name="IndeViewExport"/>\n</library:library>;' /usr/lib/openoffice/share/basic/Tools/script.xlb
	fi

	echo
	ewarn "If you install or re-install openoffice, "
	ewarn "you will need to re-merge this package."
	echo
}

pkg_postrm() {
	# Delete script from OpenOffice macros list
	if [ ! -e "${ROOT}"/usr/bin/indeview ];
	then
		if [ -e /opt/OpenOffice.org ]; then
			grep "IndeViewExport" /opt/OpenOffice.org/share/basic/Tools/script.xlb > /dev/null 2>&1 &&
				sed -i -e '/^ <library:element library:name="IndeViewExport"\/>$/d' /opt/OpenOffice.org/share/basic/Tools/script.xlb
		else
			grep "IndeViewExport" /usr/lib/openoffice/share/basic/Tools/script.xlb > /dev/null 2>&1 &&
				sed -i -e '/^ <library:element library:name="IndeViewExport"\/>$/d' /usr/lib/openoffice/share/basic/Tools/script.xlb
		fi
	fi
}
