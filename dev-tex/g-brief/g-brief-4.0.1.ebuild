# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/g-brief/g-brief-4.0.1.ebuild,v 1.2 2003/09/26 10:15:02 obz Exp $

inherit latex-package

S=${WORKDIR}/${PN}

# checksum from official ftp site changes frequently so we mirror it
DESCRIPTION="LaTeX styles for formless letters in German or English."
SRC_URI="mirror://gentoo/${P}.tar.bz2"
HOMEPAGE="ftp://ibiblio.org/pub/packages/TeX/macros/latex/contrib/supported/g-brief/"
LICENSE="LPPL-1.2"

IUSE=""
SLOT="0"
KEYWORDS="~x86 ~ppc"

# we dont need to regenerate the dvis, they come
# in the archive, see bug #28240. <obz@gentoo.org>
src_install() {

	latex-package_src_doinstall styles

	dodir /usr/share/doc/${P}
	cp *.dvi ${D}/usr/share/doc/${P}

}
