# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/giftui-cvs/giftui-cvs-0.0.1.ebuild,v 1.9 2004/05/04 05:05:06 eradicator Exp $

IUSE=""

IUSE=""

ECVS_SERVER="cvs.tuxfamily.org:/cvsroot/giftui"
ECVS_MODULE="giFTui"

inherit cvs

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="A GTK+2 giFT frontend (sources from CVS)."
HOMEPAGE="http://giftui.tuxfamily.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=x11-libs/gtk+-2.0.3
	net-p2p/gift"

src_compile() {
	./autogen.sh ${myconf} || die
	econf || die "Configure failed"
	emake || die "Make failed"
}

src_install() {
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README TODO ABOUT-NLS
	make DESTDIR="${D}" install || die "Install failed"
}
