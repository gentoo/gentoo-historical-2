# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-mailwatch/gkrellm-mailwatch-2.4.1.ebuild,v 1.3 2003/07/16 16:31:45 mholzer Exp $ 

S=${WORKDIR}/${PN}
DESCRIPTION="A GKrellM2 plugin that shows the status of additional mail boxes"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"
HOMEPAGE="http://gkrellm.luon.net/mailwatch.phtml"

DEPEND="=app-admin/gkrellm-2*"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc "

src_compile() {
	emake || die
}

src_install () {
	exeinto /usr/lib/gkrellm2/plugins
	doexe mailwatch.so
	dodoc README Changelog
}

