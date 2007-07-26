# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/hslogger/hslogger-1.0.1.ebuild,v 1.1 2007/07/26 16:28:05 dcoutts Exp $

CABAL_FEATURES="lib haddock"
inherit haskell-cabal

DESCRIPTION="A logging framework for Haskell"
HOMEPAGE="http://software.complete.org/hslogger/"
SRC_URI="http://software.complete.org/hslogger/static/download_area/1.0.1/hslogger_1.0.1.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-lang/ghc-6.4.1"

S="${WORKDIR}/${PN}"
