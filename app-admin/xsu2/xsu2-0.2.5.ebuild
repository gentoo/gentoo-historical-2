# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/xsu2/xsu2-0.2.5.ebuild,v 1.8 2004/04/15 16:22:02 kugelfang Exp $

DESCRIPTION="Interface for 'su - username -c command' in GNOME2."
SRC_URI="http://xsu.freax.eu.org/files/${P}.tar.gz"
HOMEPAGE="http://xsu.freax.eu.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~amd64"

RDEPEND="=gnome-base/libgnome-2*
	=x11-libs/gtk+-2*
	=dev-libs/glib-2*
	=x11-libs/libzvt-2*
	=gnome-base/libgnomeui-2*"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

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
