# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-python/mysql-python/mysql-python-0.9.2.ebuild,v 1.7 2003/06/21 22:30:24 drobbins Exp $

S=${WORKDIR}/MySQL-python-${PV}
DESCRIPTION="MySQL Module for python" 
SRC_URI="mirror://sourceforge/mysql-python/MySQL-python-${PV}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/mysql-python/"
LICENSE="GPL-2"
SLOT="0"
DEPEND="virtual/python
	virtual/glibc
	>=dev-db/mysql-3.22.19"
RDEPEND=""
KEYWORDS="x86 amd64 sparc "
IUSE=""

inherit distutils

src_install() {
    distutils_src_install
    
    dohtml doc/*
}

