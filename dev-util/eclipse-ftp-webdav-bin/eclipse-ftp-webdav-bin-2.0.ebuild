# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/eclipse-ftp-webdav-bin/eclipse-ftp-webdav-bin-2.0.ebuild,v 1.2 2002/07/14 05:50:27 blocke Exp $

DESCRIPTION="Eclipse FTP and WebDAV Tool"
HOMEPAGE="http://www.eclipse.org"
SRC_URI="http://64.38.198.171/downloads/drops/R-2.0-200206271835/eclipse-FTP-WebDAV-2.0.zip"
LICENSE="CPL-1.0"
SLOT="2"
KEYWORDS="x86"
DEPEND="=dev-util/eclipse-platform-bin-2.0*"
RDEPEND="$DEPEND"
S=${WORKDIR}/eclipse

src_install () {
	dodir /opt/eclipse

	cp -dpR features plugins ${D}/opt/eclipse/

	dohtml cpl-v10.html notice.html readme/*
}
