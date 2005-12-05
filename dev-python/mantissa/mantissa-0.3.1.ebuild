# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mantissa/mantissa-0.3.1.ebuild,v 1.1 2005/12/05 17:24:21 marienz Exp $

inherit distutils eutils

DESCRIPTION="An extensible, multi-protocol, multi-user, interactive application server"
HOMEPAGE="http://divmod.org/trac/wiki/DivmodMantissa"
SRC_URI="mirror://gentoo/Mantissa-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4
	>=dev-python/twisted-2.1
	>=dev-python/nevow-0.5
	>=dev-python/axiom-0.1
	>=dev-python/vertex-0.1
	>=dev-python/pytz-2005m"

S="${WORKDIR}/Mantissa-${PV}"

DOCS="NAME.txt NEWS.txt"

src_compile() {
	# skip this, or epsilon will install the temporary "build" dir
	true
}

src_test() {
	trial -R xmantissa || die "trial failed"
}
