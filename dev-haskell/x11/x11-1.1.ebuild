# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/x11/x11-1.1.ebuild,v 1.2 2007/10/31 13:12:08 dcoutts Exp $

inherit ghc-package flag-o-matic

DESCRIPTION="X11 bindings for haskell"
HOMEPAGE="http://haskell.org/ghc/"
SRC_URI=""
LICENSE="BSD"
SLOT="0"

KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="=dev-lang/ghc-6.4*"

pkg_setup () {
	ghc-package_pkg_setup
	if ! built_with_use dev-lang/ghc X; then
		eerror "This library has to be provided by ghc."
		eerror "Please re-emerge ghc with USE=\"X\""
		die "dev-haskell/x11 requires ghc to be built with USE=\"X\""
	fi
	einfo "This library is already provided by ghc. This ebuild does nothing."
}

src_install () {
	dodir "$(ghc-libdir)"
	touch "${D}/$(ghc-libdir)/.${P}.ghc-updater"
}
