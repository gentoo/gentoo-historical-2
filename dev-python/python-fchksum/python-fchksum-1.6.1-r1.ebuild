# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-fchksum/python-fchksum-1.6.1-r1.ebuild,v 1.10 2003/02/27 01:20:13 zwelch Exp $

S=${WORKDIR}/${P}
DESCRIPTION="fchksum is a Python module to find the checksum of files."
SRC_URI="http://www.azstarnet.com/~donut/programs/fchksum/${P}.tar.gz"
HOMEPAGE="http://www.azstarnet.com/~donut/programs/fchksum.html"

DEPEND="sys-libs/zlib"
KEYWORDS="x86 ppc sparc alpha hppa arm"
LICENSE="GPL-2"
SLOT="0"

inherit distutils
