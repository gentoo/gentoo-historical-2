# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mysql-python/mysql-python-1.2.1_p2.ebuild,v 1.7 2006/11/23 16:37:31 vivo Exp $

inherit distutils

S=${WORKDIR}/MySQL-python-${PV}
DESCRIPTION="MySQL Module for python"
HOMEPAGE="http://sourceforge.net/projects/mysql-python/"
SRC_URI="mirror://sourceforge/mysql-python/MySQL-python-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ppc ~ppc64 sparc x86"

IUSE="doc"

DEPEND="dev-lang/python
	virtual/mysql"

src_install() {
	distutils_src_install
	use doc && dodoc doc/*
}
