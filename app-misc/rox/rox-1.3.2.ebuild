# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/rox/rox-1.3.2.ebuild,v 1.2 2002/07/25 19:18:34 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="ROX-Filer is a fast and powerful graphical file manager"
HOMEPAGE="http://rox.sourceforge.net"
SRC_URI="mirror://sourceforge/rox/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND=">=x11-libs/gtk+-2.0.5
	>=dev-libs/glib-2.0.4
	>=dev-libs/libxml2-2.4.23
	>=x11-misc/shared-mime-info-0.7"


src_install() {

	# libxml2 header fix
	CFLAGS="${CFLAGS} -I/usr/include/libxml2/libxml -I/usr/include/libxml2"

	cd ${WORKDIR}/${P}/Choices
	mkdir -p ${D}/usr/share/Choices
	cp -rf MIME-icons/ ${D}/usr/share/Choices/
	cp -rf MIME-types/ ${D}/usr/share/Choices/
	
	cd ${WORKDIR}/${P}
	doman rox.1

	mkdir -p ${D}/usr/share/mime/mime-info
	cp rox.mimeinfo ${D}/usr/share/mime/mime-info

	mkdir -p ${D}/usr/bin	
	cp -rf ROX-Filer/ ${D}/usr/share/
	${D}/usr/share/ROX-Filer/AppRun --compile
	(cd ${D}/usr/share/ROX-Filer/src; make clean) > /dev/null
	echo "#!/bin/sh" > "${D}/usr/bin/rox"
	echo "exec /usr/share/ROX-Filer/AppRun \"\$@\"" >> "${D}/usr/bin/rox"
	chmod a+x ${D}/usr/bin/rox
}
