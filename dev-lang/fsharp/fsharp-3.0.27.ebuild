# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/fsharp/fsharp-3.0.27.ebuild,v 1.1 2013/09/24 12:22:10 cynede Exp $

EAPI="5"
USE_DOTNET="net40"

inherit autotools

DESCRIPTION="The F# Compiler"
HOMEPAGE="https://github.com/fsharp/fsharp"
SRC_URI="https://github.com/fsharp/fsharp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

MAKEOPTS="-j1" #nowarn
DEPEND="|| ( >dev-lang/mono-3.0.6 <dev-lang/mono-3.0.5 )"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_install() {
	default

	#for older software compatibility:
	dosym /usr/bin/fsharpc /usr/bin/fsc
}
