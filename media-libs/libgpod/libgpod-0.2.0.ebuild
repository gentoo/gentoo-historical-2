# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libgpod/libgpod-0.2.0.ebuild,v 1.4 2005/11/29 17:49:06 metalgod Exp $

DESCRIPTION="Shared library to access the contents of an iPod"
HOMEPAGE="http://www.gtkpod.org/libgpod.html"
SRC_URI="mirror://sourceforge/gtkpod/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="hal gtk"

RDEPEND=">=dev-libs/glib-2.4
		gtk? ( >=x11-libs/gtk+-2 )
		hal? ( >=sys-apps/dbus-0.5.2
				>=sys-apps/hal-0.5
				>=sys-apps/pmount-0.9.6 )
		sys-apps/eject"
DEPEND="${RDEPEND}
		>=dev-util/intltool-0.2.9"

pkg_setup() {
	local myconf=""
	if use hal ; then
		myconf="${myconf} --with-eject-comand=/usr/bin/eject \
				--with-unmount-command=/usr/bin/pmount"
	else
		myconf="${myconf} --with-eject-command=/usr/bin/eject \
				--with-unmount-command=/bin/umount"
	fi

}
src_compile() {

	local myconf=""
	if use hal ; then
		myconf="${myconf} --with-eject-comand=/usr/bin/eject \
						--with-unmount-command=/usr/bin/pumount"
	else
	myconf="${myconf}
		--with-eject-command=/usr/bin/eject \
		--with-unmount-command=/bin/umount"
	fi

	econf \
	${myconf} \
	|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "install failed"
}

