# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Author Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/qtella/qtella-0.4.1.ebuild,v 1.1 2002/03/12 22:02:09 verwilst Exp $
. /usr/portage/eclass/inherit.eclass || die
inherit kde-base || die

need-kde 3.*

S=${WORKDIR}/${P}a
SRC_URI="http://prdownloads.sourceforge.net/qtella/${P}a.tar.gz"
HOMEPAGE="http://www.qtella.net"
DESCRIPTION="Excellent KDE Gnutella Client"
SLOT="0"

src_compile() {

	cd ${S}
	kde_src_compile myconf
	./configure ${myconf} --with-kde-libs=${KDE3DIR}/lib --with-kde-includes=${KDE3DIR}/include --prefix=/usr || die
	emake || die

}


