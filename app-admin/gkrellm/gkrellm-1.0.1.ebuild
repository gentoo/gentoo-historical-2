# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Jerry Alexandratos <jerry@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-admin/gkrellm/gkrellm-1.0.1.ebuild,v 1.2 2000/11/05 15:44:16 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Single process stack of various system monitors"
SRC_URI="http://web.wt.net/~billw/gkrellm/${A}"

DEPEND=">=sys-libs/glibc-1.2.3
        >=x11-libs/gtk+-1.2.8
        >=media-libs/imlib-1.9.8.1"

src_compile() {
    cd ${S}
    try make
}

src_install () {
    cd ${S}/src
    insopts -o root -g root -m 755
    insinto /usr/bin
    doins gkrellm

    insinto /usr/include/gkrellm
    insopts -o root -g root -m 644
    for i in gkrellm.h gkrellm_private_proto.h gkrellm_public_proto.h
    do
      doins $i
    done

    dodir /usr/share/gkrellm
    dodir /usr/share/gkrellm/plugins
    dodir /usr/share/gkrellm/themes
    
    cd ${S}
    dodoc COPYRIGHT README Changelog 
    docinto html
    dodoc Changelog-plugins.html Changelog-themes.html Themes.html
}


