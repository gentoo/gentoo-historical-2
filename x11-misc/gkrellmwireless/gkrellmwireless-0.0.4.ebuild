# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Ben Lutgens <blutgens@gentoo.org>
# $Header: /home/cvsroot/gentoo-x86/app-misc/gkrellm-volume-0.8.ebuild,v 1.0 
# 26 Apr 2001 21:30 CST blutgens Exp $

#P=
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="A plugin for gkrellm that monitors your wireless network card"
SRC_URI="http://gkrellm.luon.net/files/${A}"
HOMEPAGE="http://gkrellm.luon.net/"

DEPEND=">=app-admin/gkrellm-1.0.6"

src_compile() {

    try make

}

src_install () {

    try make DESTDIR=${D} install
    dodoc README ChangeLog
}

