# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-bfm/gkrellm-bfm-0.5.1.ebuild,v 1.4 2002/09/12 04:17:08 owen Exp $

S=${WORKDIR}/bfm-${PV}
DESCRIPTION="A Gkrellm bubblefishymon plugin that monitors things on your machine"
SRC_URI="http://pigeond.net/bfm/bfm-${PV}.tar.bz2"
HOMEPAGE="http://pigeond.net/bfm/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND="=app-admin/gkrellm-1.2*
	>=media-libs/imlib-1.9.10-r1"

src_compile() {
	emake gkrellm || die
}

src_install () {
	exeinto /usr/lib/gkrellm/plugins
	doexe gkrellm-bfm.so
	dodoc README README.bubblemon COPYING TODO SUPPORTED_SYSTEMS
}
