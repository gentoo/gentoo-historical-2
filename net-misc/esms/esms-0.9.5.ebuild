# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/esms/esms-0.9.5.ebuild,v 1.1 2002/05/31 18:11:22 bass Exp $ 

S=${WORKDIR}/${P}

DESCRIPTION="A small console program to send messages to spanish cellular phones."
SRC_URI="http://unc.dl.sourceforge.net/sourceforge/esms/${P}.tar.gz"

HOMEPAGE="http://esms.sourceforge.net"

LICENSE="GPL"

DEPEND=">=dev-perl/libwww-perl-5.64 \
	>=dev-perl/HTML-Parser-3.26 \
	>=dev-perl/HTML-Tree-3.11
	gtk? ( net-misc/gtkesms )"
RDEPEND="${DEPEND}"
SLOT="0"
src_compile() {
	econf
	emake || die "emake failed"
}
src_install () {
	make DESTDIR=${D} install || die "install failed"
}
