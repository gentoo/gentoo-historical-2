# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/alut/alut-1.0.ebuild,v 1.1 2007/07/09 12:41:32 dcoutts Exp $

inherit ghc-package flag-o-matic

DESCRIPTION="A Haskell binding for the OpenAL Utility Toolkit"
HOMEPAGE="http://haskell.org/ghc/"
SRC_URI=""
LICENSE="BSD"
SLOT="0"

KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="=dev-lang/ghc-6.4*"

pkg_setup () {
	ghc-package_pkg_setup
	if ! ( built_with_use virtual/ghc openal && built_with_use virtual/ghc opengl ); then
		eerror "This library has to be provided by ghc."
		eerror "Please re-emerge ghc with USE=\"openal opengl\""
		die "dev-haskell/alut requires ghc to be built with USE=\"openal opengl\""
	fi
	einfo "This library is already provided by ghc. This ebuild does nothing."
}

src_install () {
	dodir "$(ghc-libdir)"
	touch "${D}/$(ghc-libdir)/.${P}.ghc-updater"
}
