# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Michael Conrad Tilstra <michael@gentoo.org> <tadpol@tadpol.org>
# $Header: /var/cvsroot/gentoo-x86/app-dicts/dictd-elements/dictd-elements-2000.22.07-r1.ebuild,v 1.6 2004/02/09 07:17:14 absinthe Exp $

MY_P=elements-20001107-pre
S=${WORKDIR}
DESCRIPTION="The elements database for dict"
SRC_URI="ftp://ftp.dict.org/pub/dict/pre/${MY_P}.tar.gz"
HOMEPAGE="http://www.dict.org"

DEPEND=">=app-text/dictd-1.5.5"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc amd64 "

src_install () {
	dodir /usr/lib/dict
	insinto /usr/lib/dict
	doins elements.dict.dz
	doins elements.index
}

# vim: ai et sw=4 ts=4
