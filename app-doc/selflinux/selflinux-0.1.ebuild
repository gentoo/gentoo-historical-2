# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/selflinux/selflinux-0.1.ebuild,v 1.3 2002/12/09 04:17:38 manson Exp $

MY_P="basisrelease"
S=${WORKDIR}/${MY_P}
DESCRIPTION="german-language hypertext tutorial about Linux"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
HOMEPAGE="http://selflinux.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc "

src_install() {
	dodir /usr/share/doc/selflinux
	cp -R * ${D}/usr/share/doc/selflinux
}
