# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-console/gkrellm-console-0.1.2.ebuild,v 1.3 2003/07/16 16:42:13 mholzer Exp $

MY_P=consolewatch-${PV}
S=${WORKDIR}/gkrellm-${MY_P}
DESCRIPTION="A GKrellM plugin that shows the users logged into each console"
SRC_URI="http://gkrellm.luon.net/files/${MY_P}.tar.gz"
HOMEPAGE="http://gkrellm.luon.net/consolewatch.phtml"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc"

DEPEND="=app-admin/gkrellm-1.2*
	>=media-libs/imlib-1.9.10-r1"

src_compile() {
	emake || die
}

src_install () {
	insinto /usr/lib/gkrellm/plugins
	doins consolewatch.so
	dodoc README Changelog TODO
}
