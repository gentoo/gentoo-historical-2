# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/rox/rox-1.3.6.ebuild,v 1.2 2003/02/13 09:08:19 vapier Exp $

IUSE=""

S=${WORKDIR}/${P}

inherit eutils
EPATCH_SOURCE="${FILESDIR}"

DESCRIPTION="ROX-Filer is a fast and powerful graphical file manager"
HOMEPAGE="http://rox.sourceforge.net"
SRC_URI="mirror://sourceforge/rox/${P}.tgz"

LICENSE="GPL-2"
SLOT="1.3"
KEYWORDS="~x86"

DEPEND=">=x11-libs/gtk+-2.0.5
	>=dev-libs/glib-2.0.4
	>=dev-libs/libxml2-2.4.23
	>=x11-misc/shared-mime-info-0.9"
#RDEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	
	epatch
}

src_install() {
	cd ${S}/Choices

	dodir /usr/share/Choices
	cp -rf MIME-icons/ ${D}/usr/share/Choices/
	cp -rf MIME-types/ ${D}/usr/share/Choices/
	
	cd ${S}
	doman rox.1

	dodir /usr/bin	
	cp -rf ROX-Filer/ ${D}/usr/share/
	${D}/usr/share/ROX-Filer/AppRun --compile
	(cd ${D}/usr/share/ROX-Filer/src; make clean) > /dev/null
	echo "#!/bin/sh" > "${D}/usr/bin/rox"
	echo "exec /usr/share/ROX-Filer/AppRun \"\$@\"" >> "${D}/usr/bin/rox"
	chmod a+x ${D}/usr/bin/rox
}
