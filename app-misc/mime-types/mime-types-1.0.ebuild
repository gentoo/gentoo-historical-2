# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mime-types/mime-types-1.0.ebuild,v 1.2 2003/02/13 09:06:33 vapier Exp $

IUSE=""
S=${WORKDIR}/${P}

DESCRIPTION="Provides mime.types file"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc alpha ppc"

DEPEND=""

RDEPEND=""

src_install() {
	dodir /etc
	insinto /etc
	doins mime.types
}