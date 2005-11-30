# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/xfsamba/xfsamba-0.47.ebuild,v 1.1.1.1 2005/11/30 09:55:30 chriswhite Exp $

DESCRIPTION="A GUI SMB network navigator"
HOMEPAGE="http://xfsamba.sourceforge.net/"
SRC_URI="http://xfsamba.sourceforge.net/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc ~amd64"
IUSE="nls"

DEPEND="=dev-libs/glib-1.2*
	=x11-libs/gtk+-1.2*
	nls? ( sys-devel/gettext )"
RDEPEND=">=net-fs/samba-2.2.4"

src_compile() {
	local myconf
	use nls || myconf="--disable-nls"

	./configure ${myconf} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--disable-gtktest \
		--disable-glibtest || die "./configure failed"

	emake || die
}

src_install () {
	make DESTDIR=${D} install || die "install failed"
}
