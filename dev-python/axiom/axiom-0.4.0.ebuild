# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/axiom/axiom-0.4.0.ebuild,v 1.1 2005/12/21 13:16:41 marienz Exp $

inherit distutils eutils

DESCRIPTION="Axiom is an object database implemented on top of SQLite."
HOMEPAGE="http://divmod.org/trac/wiki/DivmodAxiom"
SRC_URI="mirror://gentoo/Axiom-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4
	>=dev-db/sqlite-3.2.1
	>=dev-python/twisted-2.1
	>=dev-python/pysqlite-2.0
	>=dev-python/epsilon-0.4"

S="${WORKDIR}/Axiom-${PV}"

DOCS="NAME.txt"

src_compile() {
	# skip this, or epsilon will install the temporary "build" dir
	true
}

src_test() {
	trial -R axiom || die "trial failed"
}
