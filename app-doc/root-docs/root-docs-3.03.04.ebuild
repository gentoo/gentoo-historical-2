# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/root-docs/root-docs-3.03.04.ebuild,v 1.5 2002/10/04 04:03:52 vapier Exp $

S=${WORKDIR}/htmldoc
DESCRIPTION="An Object-Oriented Data Analysis Framework"
SRC_URI="ftp://root.cern.ch/root/html303.tar.gz"
HOMEPAGE="http://root.cern.ch/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86"

src_compile() {

	einfo "Nothing to compile."

}

src_install() {
	dohtml *
	docinto postscript
	dodoc *.ps
}
