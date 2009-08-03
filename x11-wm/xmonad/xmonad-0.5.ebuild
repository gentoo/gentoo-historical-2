# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/xmonad/xmonad-0.5.ebuild,v 1.2 2009/08/03 10:35:43 ssuominen Exp $

CABAL_FEATURES="bin lib profile haddock"
CABAL_MIN_VERSION=1.2

inherit haskell-cabal

DESCRIPTION="A lightweight X11 window manager"
HOMEPAGE="http://www.xmonad.org/"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

DEPEND="dev-haskell/mtl
	>=dev-haskell/x11-1.4
	>=dev-lang/ghc-6.6"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}

	# -Wall -Werror is really fragile.
	# portage strips, packages should not do it themselves.
	sed -i -e 's/-Wall -Werror -optl-Wl,-s//' "${S}/xmonad.cabal"
}

src_install() {
	cabal_src_install

	echo -e "#!/bin/sh\n/usr/bin/xmonad" > "${T}/${PN}"
	exeinto /etc/X11/Sessions
	doexe "${T}/${PN}"

	insinto /usr/share/xsessions
	doins "${FILESDIR}/${PN}.desktop"

	doman man/xmonad.1
}
