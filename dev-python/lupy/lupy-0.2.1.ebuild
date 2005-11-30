# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/lupy/lupy-0.2.1.ebuild,v 1.1 2004/06/07 14:51:35 lordvan Exp $

inherit distutils

MY_PN="Lupy"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Lupy is a is a full-text indexer and search engine written in Python."
HOMEPAGE="http://www.divmod.org/Lupy/index.html"
SRC_URI="mirror://sourceforge/lupy/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~s390"
IUSE=""

DEPEND=">=dev-lang/python-2.2"

S=${WORKDIR}/${MY_P}

