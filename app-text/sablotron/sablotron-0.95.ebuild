# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/sablotron/sablotron-0.95.ebuild,v 1.5 2002/12/09 04:17:45 manson Exp $

MY_P="Sablot-${PV}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="An XSLT Parser in C++"
SRC_URI="http://www.gingerall.com/perl/rd?url=sablot/${MY_P}.tar.gz"
HOMEPAGE="http://www.gingerall.com/charlie-bin/get/webGA/act/sablotron.act"

SLOT="0"
LICENSE="MPL-1.1"
KEYWORDS="x86 sparc "

DEPEND=">=dev-libs/expat-1.95.1 "


src_compile() {
	
	local myconf
	
	use perl && myconf="--enable-perlconnect"
	
	econf \
		--enable-javascript \
		${myconf} || die
	emake || die
}

src_install () {
	einstall || die
	dodoc README* RELEASE
	dodoc src/TODO
}
