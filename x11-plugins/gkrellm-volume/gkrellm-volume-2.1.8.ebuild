# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-volume/gkrellm-volume-2.1.8.ebuild,v 1.7 2004/06/24 22:58:24 agriffis Exp $

IUSE=""
MY_P=${PN}2-${PV}
S=${WORKDIR}/${PN}
DESCRIPTION="A mixer control plugin for gkrellm"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"
HOMEPAGE="http://gkrellm.luon.net/volume.phtml"

DEPEND="=app-admin/gkrellm-2*"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc alpha"

src_compile() {
	make || die
}

src_install () {
	insinto /usr/lib/gkrellm2/plugins
	doins volume.so
	dodoc README Changelog
}
