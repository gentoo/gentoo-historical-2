# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellmitime/gkrellmitime-0.4.ebuild,v 1.8 2004/06/24 22:55:13 agriffis Exp $

IUSE=""
S=${WORKDIR}/${PN}
DESCRIPTION="Internet Time plugin for Gkrellm"
SRC_URI="http://eric.bianchi.free.fr/gkrellm/${P}.tar.gz"
HOMEPAGE="http://eric.bianchi.free.fr/gkrellm/"

DEPEND="=app-admin/gkrellm-1.2*"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc "

src_compile() {
	emake || die
}

src_install () {
	insinto /usr/lib/gkrellm/plugins
	doins gkrellm_itime.so
	dodoc README ChangeLog COPYING
}
