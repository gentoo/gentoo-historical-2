# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbweather/bbweather-0.5.ebuild,v 1.3 2002/09/21 04:16:18 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="blackbox weather monitor"
SRC_URI="http://www.netmeister.org/apps/${P}.tar.bz2"
HOMEPAGE="http://www.netmeister.org/apps/bbweather/"

SLOT="0"
LICENSE="GPL"
KEYWORDS="*"

DEPEND="virtual/blackbox
	>=net-misc/wget-1.7
	>=sys-devel/perl-5.6.1"

src_compile() {
	econf || die
	emake || die
}

src_install () {

	make DESTDIR=${D} install || die
	rm -rf ${D}/usr/share/doc
	dodoc README COPYING AUTHORS INSTALL ChangeLog NEWS TODO data/README.bbweather
	dohtml -r doc
}
