# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellmouse/gkrellmouse-0.0.2.ebuild,v 1.4 2002/10/04 06:45:24 vapier Exp $

MY_P=${P/-/_}
S=${WORKDIR}/${P}
DESCRIPTION="A Gkrellm plugin that tracks the total distance of mouse movements"
SRC_URI="http://ssl.usu.edu/paul/gkrellmouse/${MY_P}.tar.gz"
HOMEPAGE="http://ssl.usu.edu/paul/gkrellmouse"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND="=app-admin/gkrellm-1.2*
	>=media-libs/imlib-1.9.10-r1"

src_compile() {
	emake || die
}

src_install () {
	exeinto /usr/lib/gkrellm/plugins
	doexe gkmouse.so
	dodoc README COPYING Changelog
}
