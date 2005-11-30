# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/comedilib/comedilib-0.7.21.ebuild,v 1.1.1.1 2005/11/30 10:09:21 chriswhite Exp $

IUSE="python doc"
DESCRIPTION="comedilib - Userspace utility for comedi"
SRC_URI="ftp://ftp.comedi.org/pub/comedi/${P}.tar.gz"
HOMEPAGE="http://www.comedi.org"
KEYWORDS="x86"
LICENSE="LGPL-2.1"
SLOT="0"

DEPEND=">=sci-misc/comedi-0.7.63
	python? ( dev-lang/python )
	doc? ( app-text/docbook2X )"

src_compile()
{
	./configure --prefix=${D}/usr --localstatedir=${D}/var
	make
}

src_install()
{
	make install
	keepdir /var/calibrations
}

