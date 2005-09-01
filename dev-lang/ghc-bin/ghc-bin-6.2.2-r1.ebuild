# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ghc-bin/ghc-bin-6.2.2-r1.ebuild,v 1.5 2005/09/01 14:51:26 gustavoz Exp $

IUSE="" # use the non-binary version if you want to have more choice

DESCRIPTION="Glasgow Haskell Compiler"
# list all arches for proper digest building:
SRC_URI="x86? (  mirror://gentoo/${P}-r1-x86.tbz2 )
		ppc? ( mirror://gentoo/${P}-r1-ppc.tbz2 )
		sparc? ( mirror://gentoo/${P}-r1-sparc.tbz2 )"
HOMEPAGE="http://www.haskell.org/ghc/"

LICENSE="as-is"
KEYWORDS="x86 -amd64 ~ppc sparc -alpha"
SLOT="0"

RESTRICT="nostrip" # already stripped

LOC="/opt/ghc"

DEPEND=""
RDEPEND=">=dev-lang/perl-5.6.1
	>=sys-devel/gcc-2.95.3
	>=dev-libs/gmp-4.1
	=sys-libs/readline-5*"

PROVIDE="virtual/ghc"

S="${WORKDIR}"

src_compile() {
	sed -i "s|/usr|${LOC}|g" usr/bin/* usr/lib/ghc-${PV}/package.conf
	mkdir -p ./${LOC}
	mv usr/* ./${LOC}
}

src_install () {
	mv * ${D}
	insinto /etc/env.d
	doins ${FILESDIR}/10ghc
}
