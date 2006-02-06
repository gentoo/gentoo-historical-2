# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mysql-python/mysql-python-1.2.0-r1.ebuild,v 1.1 2006/02/06 21:58:31 liquidx Exp $

inherit distutils eutils

S=${WORKDIR}/MySQL-python-${PV}
DESCRIPTION="MySQL Module for python"
HOMEPAGE="http://sourceforge.net/projects/mysql-python/"
SRC_URI="mirror://sourceforge/mysql-python/MySQL-python-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"

IUSE=""

DEPEND="dev-lang/python
	>=dev-db/mysql-5"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-newdecimal.patch
}

src_compile() {
	export mysqlclient="mysqlclient_r"
	distutils_src_compile
}

src_install() {
	distutils_src_install
	dohtml doc/*
}
