# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/omnibook/omnibook-20021016.ebuild,v 1.5 2004/03/14 10:59:03 mr_bones_ Exp $

MY_PV="2002-10-16"
MY_P=${PN}-${MY_PV}

DESCRIPTION="Linux kernel module for HP Omnibook support"
HOMEPAGE="http://www.sourceforge.net/projects/omke"
SRC_URI="mirror://sourceforge/omke/omnibook-2002-10-16.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/kernel"

S=${WORKDIR}/${MY_P}

src_compile() {
	emake CC="gcc ${CFLAGS}" || die
}

src_install() {
	make MODDIR="${D}/lib/modules" DEPMOD="" install
	dodoc ${S}/doc/*
}
