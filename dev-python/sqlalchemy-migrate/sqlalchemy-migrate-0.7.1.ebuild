# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sqlalchemy-migrate/sqlalchemy-migrate-0.7.1.ebuild,v 1.1 2011/09/03 18:16:27 djc Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="SQLAlchemy Schema Migration Tools"
HOMEPAGE="http://code.google.com/p/sqlalchemy-migrate/ http://pypi.python.org/pypi/sqlalchemy-migrate"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/decorator
	dev-python/setuptools
	>=dev-python/sqlalchemy-0.5
	dev-python/tempita"
RDEPEND="${DEPEND}"
# for tests: unittest2 and scripttest

PYTHON_MODNAME="migrate"
