# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/ickle/ickle-0.3.1.ebuild,v 1.10 2003/09/05 23:58:58 msterret Exp $

IUSE="spell gnome"

S=${WORKDIR}/${P}
DESCRIPTION="ICQ 200x compatible ICQ client. limited featureset."
SRC_URI="mirror://sourceforge/ickle/${P}.tar.gz"
HOMEPAGE="http://ickle.sf.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"


DEPEND="=x11-libs/gtk+-1.2*
	=dev-cpp/gtkmm-1.2*
	=dev-libs/libsigc++-1.0*
	>=sys-libs/lib-compat-1.0
	=net-libs/libicq2000-0.3.1
	spell? ( app-text/ispell )
	gnome? ( =gnome-base/gnome-applets-1.4*
		=gnome-base/gnome-libs-1.4* )"

src_compile() {

	local myconf
	myconf=""
	use gnome \
		&& myconf="--with-gnome" \
		|| myconf="--without-gnome"

	econf \
		--localstatedir=/var/lib \
		${myconf} || die "./configure failed"
	emake || die

}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS  COPYING ChangeLog  INSTALL NEWS README THANKS TODO
}
