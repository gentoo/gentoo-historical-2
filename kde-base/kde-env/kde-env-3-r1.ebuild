# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kde-env/kde-env-3-r1.ebuild,v 1.4 2002/10/04 05:40:39 vapier Exp $

DESCRIPTION="Sets up some env.d files for kde"
SRC_URI=""
HOMEPAGE="http://www.gentoo.org/"
DEPEND=""
KEYWORDS="x86 ppc sparc sparc64" # works everywhere - nothing to compile, no deps
LICENSE="GPL-2" # like the ebuild itself
SLOT="0"

src_unpack() { true; }
src_compile() { true; }

src_install() {

    dodir /etc/env.d
    echo "KDEDIRS=/usr" > ${D}/etc/env.d/99kde-env

}
