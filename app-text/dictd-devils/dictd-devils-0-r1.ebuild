# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Michael Conrad Tilstra <michael@gentoo.org> <tadpol@tadpol.org>
# $Header: /var/cvsroot/gentoo-x86/app-text/dictd-devils/dictd-devils-0-r1.ebuild,v 1.5 2002/08/16 02:42:01 murphy Exp $

MY_P=devils-dict-pre
S=${WORKDIR}
SRC_URI="ftp://ftp.dict.org/pub/dict/pre/${MY_P}.tar.gz"
HOMEPAGE="http://www.dict.org"
DESCRIPTION="The Devil's Dictionary for dict"

DEPEND=">=app-text/dictd-1.5.5"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64"

src_install () {
	dodir /usr/lib/dict
	insinto /usr/lib/dict
	doins devils.dict.dz
	doins devils.index
}

# vim: ai et sw=4 ts=4
