# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Seemant Kulleen <seemant@rocketmail.com>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/gkrellmwho/gkrellmwho-0.4.ebuild,v 1.4 2002/07/08 16:58:06 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GKrellM plugin which displays users logged in"
SRC_URI="http://web.wt.net/~billw/gkrellm/Plugins/${P}.tar.gz"
HOMEPAGE="http://web.wt.net/~billw/gkrellm/Plugins"
LICENSE="LGPL-2.1"

DEPEND=">=app-admin/gkrellm-1.0.6"

src_compile() {
    emake || die
}

src_install () {
    insinto /usr/lib/gkrellm/plugins
    doins gkrellmwho.so
    dodoc README 
}
