# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/xmlto/xmlto-0.0.15.ebuild,v 1.8 2003/11/22 17:44:55 weeve Exp $

DESCRIPTION="A bash script for converting XML and DocBook formatted documents to a variety of output formats"
HOMEPAGE="http://cyberelk.net/tim/xmlto/"
SRC_URI="http://cyberelk.net/tim/data/${PN}/stable/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
IUSE=""
KEYWORDS="~x86 ~ppc ~sparc"

DEPEND="app-shells/bash
	dev-libs/libxslt
	>=app-text/docbook-xsl-stylesheets-1.62.0-r1"
#	tetex? ( >=app-text/passivetex-1.4 )"
# Passivetex/xmltex need some sorting out, we'll include pdf/dvi/tex 
# support in the first revision to xmlto <obz@gentoo.org>

# not parrallel safe, thanks <agriffis@gentoo.org>, bug #33151
MAKEOPTS="${MAKEOPTS} -j1"

src_unpack() {

	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-head-fix.patch

}

src_compile() {

	econf || die
	emake || die

}

src_install() {

	make DESTDIR=${D} prefix="/usr" install || die
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README
	docinto xml
	dodoc doc/*.xml

}

