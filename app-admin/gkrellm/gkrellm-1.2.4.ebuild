# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Jerry A! <jerry@thehutt.org>
# $Id: gkrellm-1.2.4.ebuild,v 1.3 2001/11/27 07:45:29 jerrya Exp $



S=${WORKDIR}/${P}
DESCRIPTION="Single process stack of various system monitors"
SRC_URI="http://web.wt.net/~billw/gkrellm/${P}.tar.gz"
HOMEPAGE="http://www.gkrellm.net/"

DEPEND="virtual/glibc
	>=x11-libs/gtk+-1.2.10-r4
	>=media-libs/imlib-1.9.10-r1"


src_compile() {
	emake  PREFIX=/usr prefix=/usr || die
}

src_install() {
	cd ${S}/src

	exeinto /usr/bin
	doexe gkrellm

	insinto /usr/include/gkrellm
	for i in gkrellm.h gkrellm_private_proto.h gkrellm_public_proto.h
	do
		doins $i
	done

	dodir /usr/share/gkrellm/{themes,plugins}

	cd ${S}

	dodoc COPYRIGHT README Changelog
	docinto html
	dodoc Changelog-plugins.html Changelog-themes.html Themes.html
}
