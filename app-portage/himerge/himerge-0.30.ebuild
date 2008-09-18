# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/himerge/himerge-0.30.ebuild,v 1.1 2008/09/18 17:18:36 araujo Exp $

inherit base haskell-cabal

DESCRIPTION="Haskell Graphical User Interface for the Gentoo's Portage System."
HOMEPAGE="http://www.haskell.org/himerge/"
SRC_URI="http://www.haskell.org/himerge/release/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.8.2
	>=dev-haskell/gtk2hs-0.9.12.1
	dev-haskell/parallel
	>=app-portage/eix-0.9.3
	>=app-portage/gentoolkit-0.2.3
	>=app-portage/portage-utils-0.1.28
	>=dev-haskell/filepath-1.0"
RDEPEND=""

pkg_setup() {
	if ! built_with_use -o dev-haskell/gtk2hs firefox seamonkey xulrunner; then
	   	echo
		eerror "gtk2hs was not merged with the firefox, seamonkey or xulrunner USE flag."
		eerror "Himerge requires gtk2hs to be compiled with any of these flags."
		die "gtk2hs missing web browser support."
	fi
}

src_install() {
	cabal_src_install
	# Give suid privileges.
	fperms 4111 /usr/bin/hima
}

pkg_postinst() {
	enewgroup himerge
	ewarn "In order to run this Himerge version you have to"
	ewarn "be in the 'himerge' group."
	case ${CHOST} in
		*-darwin*) ewarn "Just run 'niutil -appendprop / /groups/himerge users <USER>'";;
		*-freebsd*|*-dragonfly*) ewarn "Just run 'pw groupmod himerge -m <USER>'";;
		*) ewarn "Just run 'gpasswd -a <USER> himerge', then have <USER> re-login.";;
	esac
	echo
}
