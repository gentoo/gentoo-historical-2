# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/knutclient/knutclient-0.8.1_pre2.ebuild,v 1.1 2004/05/26 00:29:12 caleb Exp $

inherit kde
need-kde 3.1

MY_PV=${PV/_/-}
S=${WORKDIR}/${P}
DESCRIPTION="Client for the NUT UPS monitoring daemon"
SRC_URI="ftp://ftp.buzuluk.cz/pub/alo/${PN}/devel/${PN}-${MY_PV}.tar.gz"
HOMEPAGE="http://www.alo.cz/knutclient-pop-en.html"
KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"

src_compile() {
	econf || die
	emake || die
}

src_install() {

	# Makefile: user/group nut might not exist until after
	# pkg_preinst() runs; so use root for now, and fix it
	# up in pkg_postinst().
	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING ChangeLog INSTALL README TODO
}
