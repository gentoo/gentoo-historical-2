# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-seti/gkrellm-seti-0.7.0b.ebuild,v 1.7 2004/06/24 22:57:41 agriffis Exp $

IUSE=""
S=${WORKDIR}/${P//gkrellm-}
DESCRIPTION="a Seti@Home Monitor Plugin for Gkrellm"
SRC_URI="http://xavier.serpaggi.free.fr/seti/${P//gkrellm-}.tar.bz2"
HOMEPAGE="http://xavier.serpaggi.free.fr/seti"

DEPEND="=app-admin/gkrellm-1.2*"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc "

src_compile() {
	make || die
}

src_install () {
	exeinto /usr/lib/gkrellm/plugins
	doexe seti.so
	dodoc README ChangeLog COPYING NEWS
}
