# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellmwireless/gkrellmwireless-2.0.3.ebuild,v 1.4 2004/04/30 21:24:47 pvdabeel Exp $

IUSE=""
S=${WORKDIR}/${PN}
DESCRIPTION="A plugin for GKrellM that monitors your wireless network card"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"
HOMEPAGE="http://gkrellm.luon.net/"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="x86 ppc ~sparc"

DEPEND="=app-admin/gkrellm-2*"


src_compile() {
	export PATH="${PATH}:/usr/X11R6/bin"
	make || die

}

src_install () {
	insinto /usr/lib/gkrellm2/plugins
	doins wireless.so
	dodoc README Changelog
}
