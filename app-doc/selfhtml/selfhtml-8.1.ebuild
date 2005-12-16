# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/selfhtml/selfhtml-8.1.ebuild,v 1.2 2005/12/16 11:04:24 flameeyes Exp $

S=${WORKDIR}
TARGET=/usr/share/doc/${PF}/html
DESCRIPTION="\"The\" German HTML/XHTML/CSS/XML/DHTML/CGI/Perl/JavaScript Documentation"
SRC_URI="http://aktuell.de.selfhtml.org/cgi-bin/selfdown/download.pl/selfhtml81.zip"
HOMEPAGE="http://selfhtml.org"
DEPEND="app-arch/unzip"
SLOT="0"
LICENSE="selfhtml"
KEYWORDS="x86 ppc sparc alpha mips hppa amd64"
IUSE=""

src_install() {
	dodir ${TARGET}
	cp -pPR ${S}/* ${D}${TARGET}
}
