# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/xsu2/xsu2-0.2.5.ebuild,v 1.3 2003/02/13 05:33:23 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Interface for 'su - username -c command' in GNOME2."
SRC_URI="http://xsu.freax.eu.org/files/${P}.tar.gz"
HOMEPAGE="http://xsu.freax.eu.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="=gnome-base/libgnome-2* 
	=x11-libs/gtk+-2*
	=dev-libs/glib-2*
	=x11-libs/libzvt-2*
	=gnome-base/libgnomeui-2*"

RDEPEND=""

src_compile() {
	econf \
		--prefix=/usr || die
	emake || die
}

src_install() {
	dobin src/xsu
	doman doc/xsu.8
	dodoc ABOUT-NLS AUTHORS COPYING ChangeLog INSTALL NEWS README TODO
	dohtml -r doc/xsu_*
}
