# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/html/html-1.0.ebuild,v 1.5 2007/03/15 17:28:30 corsair Exp $

inherit ghc-package

DESCRIPTION="HTML Haskell combinator library."
HOMEPAGE="http://haskell.org/ghc/"
SRC_URI=""
LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64 hppa ppc64 sparc x86"
IUSE=""

DEPEND="=virtual/ghc-6.4*"

pkg_setup () {
	ghc-package_pkg_setup
	einfo "This library is already provided by ghc. This ebuild does nothing."
}

src_install () {
	dodir "$(ghc-libdir)"
	touch "${D}/$(ghc-libdir)/.${P}.ghc-updater"
}
