# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/gkrellmwireless/gkrellmwireless-2.0.0.ebuild,v 1.4 2002/12/11 15:01:19 seemant Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="A plugin for GKrellM that monitors your wireless network card"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"
HOMEPAGE="http://gkrellm.luon.net/"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc "

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
