# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-cdread/xmms-cdread-0.14a.ebuild,v 1.1 2002/10/25 08:10:05 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="XMMS plugin to read audio cdroms as data"
HOMEPAGE="ftp://mud.stack.nl/pub/OuterSpace/willem/"
SRC_URI="ftp://mud.stack.nl/pub/OuterSpace/willem/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

DEPEND="media-sound/xmms"

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS README ChangeLog INSTALL NEWS TODO
}
