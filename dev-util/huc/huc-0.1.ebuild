# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Mike Jones <ashmodai@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-util/huc/huc-0.1.ebuild,v 1.1 2002/05/22 20:26:24 ashmodai Exp $

S=${WORKDIR}/${P}
DESCRIPTION="HTML umlaut conversion tool"
SRC_URI="http://www.int21.de/huc/huc-0.1.tar.bz2"
HOMEPAGE="http://www.int21.de/huc/"
DEPEND=""
LICENCE="GPL"
SLOT="0"
RDEPEND=""

src_compile() 
{
	emake CFLAGS="${CFLAGS}" || die
}

src_install () 
{
	dobin huc
	dodoc README COPYING
}
			
