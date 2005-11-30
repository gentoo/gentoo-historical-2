# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/javatoolkit/javatoolkit-0.1.0.ebuild,v 1.1.1.1 2005/11/30 09:47:32 chriswhite Exp $

DESCRIPTION="Collection of Gentoo-specific tools for Java"
HOMEPAGE="http://dev.gentoo.org/~karltk/projects/java/"
SRC_URI="http://dev.gentoo.org/~karltk/projects/java/distfiles/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

src_compile() {
	true
}
src_install() {
	make DESTDIR=${D} install || die
}
