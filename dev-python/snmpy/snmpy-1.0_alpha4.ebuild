# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/snmpy/snmpy-1.0_alpha4.ebuild,v 1.16 2004/06/25 01:50:22 agriffis Exp $

inherit distutils

TARNAME=snmpy-alpha-4
S=${WORKDIR}/${TARNAME}

DESCRIPTION="Python SNMP interface"
SRC_URI="mirror://sourceforge/snmpy/${TARNAME}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/snmpy/"

IUSE=""
LICENSE="CNRI"
SLOT="0"
KEYWORDS="x86 sparc alpha"

DEPEND="virtual/python
	virtual/snmp"

mydocs="RELEASE-NOTES docs/docs.html"
