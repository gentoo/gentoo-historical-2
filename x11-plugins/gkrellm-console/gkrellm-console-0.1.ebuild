# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-console/gkrellm-console-0.1.ebuild,v 1.4 2002/10/04 06:44:43 vapier Exp $

MY_P=consolewatch-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A GKrellM plugin that shows the users logged into each console"
SRC_URI="http://gkrellm.luon.net/files/${MY_P}.tar.gz"
HOMEPAGE="http://gkrellm.luon.net/consolewatch.phtml"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc sparc64"

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
