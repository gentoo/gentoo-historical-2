# Copyright 2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/aatv/aatv-0.2.ebuild,v 1.1 2003/02/12 06:23:38 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="watch TV on a text console rendered by aalib"
SRC_URI="http://n00n.free.fr/aatv/${P}.tar.gz"
HOMEPAGE="http://n00n.free.fr/aatv/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="media-libs/aalib"

src_install () {
	make DESTDIR=${D} AATV_CONFIGFILE=${D}/etc/${PN}.conf install || die

	dodoc AUTHORS NEWS README TODO
}
