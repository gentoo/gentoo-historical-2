# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/psyco/psyco-1.4.ebuild,v 1.2 2005/10/16 22:00:09 kloeri Exp $

inherit distutils

HOMEPAGE="http://psyco.sourceforge.net/"
DESCRIPTION="Psyco is a Python extension module which can massively speed up the execution of any Python code."
SRC_URI="mirror://sourceforge/psyco/${P}-src.tar.gz"

IUSE=""
SLOT="0"
LICENSE="MIT"
KEYWORDS="x86"
DEPEND=">=dev-lang/python-2.1"

src_install() {
	distutils_src_install
	insinto /usr/share/doc/${PF}/examples
	doins ${S}/test/*
}
