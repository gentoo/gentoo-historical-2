# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Seemant Kulleen <seemant@rocketmail.com>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/glogwatch/glogwatch-1.0.ebuild,v 1.1 2002/02/20 02:50:33 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A Gkrellm plugin that tracks a log file."
SRC_URI="http://www.uberh4x0r.org/download/gkrellm/${P}.tar.gz"
HOMEPAGE="http://www.uberh4x0r.org/download/gkrellm"

DEPEND=">=app-admin/gkrellm-1.0.6
	>=x11-libs/gtk+-1.2.10-r4
	>=media-libs/imlib-1.9.10-r1"

src_compile() {
	emake || die
}

src_install () {
	exeinto /usr/lib/gkrellm/plugins
	doexe glogwatch.so
	dodoc README COPYRIGHT
}
