# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/sylpheed-theme/sylpheed-theme-2.ebuild,v 1.2 2002/06/29 10:11:34 seemant Exp $

DESCRIPTION="Theme packs for sylpheed and sylpheed-claws and sylpheed-claws-nc"

HOMEPAGE="http://sylpheed-claws.sourceforge.net/"
SLOT="0"
LICENSE="GPL-2"

RDEPEND="net-mail/sylpheed-claws"

MY_P=${PN}-pak${PV}
SRC_URI="mirror://sourceforge/sylpheed-claws/${MY_P}.tar.bz2"

S=${WORKDIR}

src_compile() {

	einfo "Nothing to compile"
}

src_install () {

	THEMEDIR=/usr/share/sylpheed/themes
	dodir ${THEMEDIR}

	cp -a * ${D}/${THEMEDIR}

	rm ${D}/${THEMEDIR}/README

	dodoc README
}
