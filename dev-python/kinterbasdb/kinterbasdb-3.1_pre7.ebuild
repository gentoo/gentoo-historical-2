# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/kinterbasdb/kinterbasdb-3.1_pre7.ebuild,v 1.2 2004/06/25 01:32:31 agriffis Exp $

inherit distutils

DESCRIPTION="kinterbasdb - firebird/interbase interface for Python."
SRC_URI="mirror://sourceforge/kinterbasdb/${P}.src.tar.gz"
HOMEPAGE="http://kinterbasdb.sourceforge.net"

IUSE=""
LICENSE="kinterbasdb"
SLOT="0"
KEYWORDS="~x86 -sparc"

DEPEND="dev-lang/python
	>=dev-db/firebird-1.0_rc1
	>=dev-python/egenix-mx-base-2.0.1"

src_install() {
	mydoc="docs/*.txt"
	distutils_src_install --install-data=/usr/share/doc/${PF}

	# we put docs in properly ourselves
	rm -rf ${D}/usr/share/doc/${PF}/kinterbasdb
	dohtml docs/*.html docs/*.css
}
