# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-volume/gkrellm-volume-2.1.9.ebuild,v 1.6 2004/02/28 17:58:57 aliz Exp $

DESCRIPTION="A mixer control plugin for gkrellm"
HOMEPAGE="http://gkrellm.luon.net/volume.phtml"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="x86 ~ppc sparc ~alpha amd64"

DEPEND="=app-admin/gkrellm-2*"

S=${WORKDIR}/${PN}

src_compile() {
	make || die
}

src_install() {
	insinto /usr/lib/gkrellm2/plugins
	doins volume.so
	dodoc README Changelog
}
