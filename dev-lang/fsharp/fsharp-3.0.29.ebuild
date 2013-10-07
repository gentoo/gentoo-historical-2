# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/fsharp/fsharp-3.0.29.ebuild,v 1.1 2013/10/07 05:38:10 cynede Exp $

EAPI="5"

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils mono-env

DESCRIPTION="The F# Compiler"
HOMEPAGE="https://github.com/fsharp/fsharp"
SRC_URI="https://github.com/fsharp/fsharp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

MAKEOPTS+=" -j1" #nowarn
DEPEND="dev-lang/mono"
RDEPEND="${DEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

src_install() {
	default

	#for older software compatibility:
	dosym fsharpc /usr/bin/fsc
}
