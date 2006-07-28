# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/orm/orm-1.0.1.ebuild,v 1.2 2006/07/28 12:03:51 liquidx Exp $

inherit distutils

DESCRIPTION="The Object Relational Membrane is an attempt to write an Object Relational Layer that is as thin as possible."
HOMEPAGE="http://www.tux4web.de/computer/software/orm/"
SRC_URI="http://www.tux4web.de/computer/software/orm/download/${P}.tar.gz"

DEPEND="virtual/python
	dev-python/egenix-mx-base
	firebird? ( >=dev-python/kinterbasdb-3.1_pre7 )
	mysql? ( >=dev-python/mysql-python-0.9.2 )
	postgres? ( <dev-python/psycopg-1.99 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="firebird mysql postgres"

pkg_setup() {
	( use firebird || use mysql || use postgres ) || \
	die "Using orm without any db makes no sense. Please enable at least one use flag."
}
