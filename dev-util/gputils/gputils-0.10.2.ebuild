# Copyright 1999-2002 Gentoo Technologies, Inc. 
# Distributed under the terms of the GNU General Public License, v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gputils/gputils-0.10.2.ebuild,v 1.5 2002/08/16 04:04:41 murphy Exp $

S=${WORKDIR}/${P} 
DESCRIPTION="Utils for the PICxxx procesors" 
SRC_URI="mirror://sourceforge/gputils/${P}.tar.gz" 
HOMEPAGE="http://gputils.sourceforge.net/" 
 
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64"

DEPEND="virtual/glibc"

src_compile(){ 
 
 	econf || die
	emake || die
} 
 
src_install() { 
	einstall || die
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README TODO
	dodoc doc/gputils.ps
}
