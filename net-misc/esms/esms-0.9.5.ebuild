# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/esms/esms-0.9.5.ebuild,v 1.14 2004/06/24 23:43:36 agriffis Exp $

S=${WORKDIR}/${P}

DESCRIPTION="A small console program to send messages to spanish cellular phones"
SRC_URI="mirror://sourceforge/esms/${P}.tar.gz"
HOMEPAGE="http://esms.sourceforge.net"
KEYWORDS="x86 sparc "
LICENSE="GPL-2"
SLOT="0"

DEPEND=">=dev-perl/libwww-perl-5.64 \
	>=dev-perl/HTML-Parser-3.26 \
	>=dev-perl/HTML-Tree-3.11
	>=dev-lang/perl-5.6.1"


src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	make DESTDIR=${D} install || die "install failed"
}

