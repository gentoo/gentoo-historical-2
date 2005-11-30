# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ledit/ledit-1.11.ebuild,v 1.1.1.1 2005/11/30 10:06:03 chriswhite Exp $

IUSE=""

DESCRIPTION="A line editor to be used with interactive commands."
SRC_URI="ftp://ftp.inria.fr/INRIA/Projects/cristal/Daniel.de_Rauglaudre/Tools/${P}.tar.gz"
HOMEPAGE="http://cristal.inria.fr/~ddr/"

DEPEND=">=dev-lang/ocaml-3.06"
RDEPEND=""

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 ppc ~amd64"

src_compile()
{
	make || die "make failed"
	make ledit.opt || die "make failed"
}

src_install()
{
	newbin ledit.opt ledit
	newman ledit.l ledit.1
	dodoc Changes LICENSE README
}
