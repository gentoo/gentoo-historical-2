# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-util/uml/uml-1.0.3.ebuild,v 1.4 2002/07/11 06:30:25 drobbins Exp $

inherit kde-base
 
DESCRIPTION="KDE 2.2 UML Drawing Utility"
SRC_URI="mirror://sourceforge/uml/${P}-1.tar.gz"
HOMEPAGE="http://uml.sourceforge.net"

newdepend ">=kde-base/kdebase-2.2 virtual/glibc"

need-kde 2.2

src_compile() {
	kde_src_compile myconf
	myconf="$myconf --mandir=${D}/usr/share/man"
	kde_src_compile configure make
}

