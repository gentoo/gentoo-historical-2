# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/gensig/gensig-2.3.ebuild,v 1.1 2003/10/19 18:02:18 lanius Exp $

DESCRIPTION="Random ~/.signature generator"
HOMEPAGE="http://www.geekthing.com/~robf/gensig/ChangeLog"
SRC_URI="http://www.geekthing.com/~robf/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
DEPEND="virtual/glibc"

src_install () {
	make DESTDIR=${D} install || die
}
