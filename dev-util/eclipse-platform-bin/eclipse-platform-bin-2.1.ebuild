# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/eclipse-platform-bin/eclipse-platform-bin-2.1.ebuild,v 1.6 2004/03/13 01:49:46 mr_bones_ Exp $

DESCRIPTION="Eclipse Tools Platform, basic platform binary"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/downloads/drops/R-2.1-200303272130/eclipse-platform-2.1-linux-gtk.zip"

SLOT="2"
LICENSE="CPL-1.0"
KEYWORDS="~x86 ~sparc"

DEPEND=">=virtual/jdk-1.2
	=x11-libs/gtk+-2*"

S=${WORKDIR}/eclipse

src_install() {
	dodir /opt/eclipse

	cp -dpR features install.ini eclipse icon.xpm plugins startup.jar \
		${D}/opt/eclipse/

	dohtml cpl-v10.html notice.html readme/*

	insinto /usr/share/gnome/apps/Development
	doins ${FILESDIR}/eclipse.desktop

	dodir /etc/env.d
	echo "LDPATH=/opt/eclipse" > ${D}/etc/env.d/20eclipse
}
