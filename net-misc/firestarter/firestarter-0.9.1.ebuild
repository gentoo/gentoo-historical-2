# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/firestarter/firestarter-0.9.1.ebuild,v 1.1 2003/01/31 21:11:52 foser Exp $

IUSE="nls"

S=${WORKDIR}/${P}
DESCRIPTION="Gui for iptables firewall setup and monitor."
SRC_URI="mirror://sourceforge/firestarter/${P}.tar.gz"
HOMEPAGE="http://firestarter.sf.net"
LICENSE="GPL-2"

RDEPEND=">=x11-libs/gtk+-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/libgnome-2	
	sys-apps/iptables"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	>=dev-util/intltool-0.21"

SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"

src_compile() {
	local myconf
	use nls \
		&& myconf="${myconf} --enable-nls" \
		|| myconf="${myconf} --disable-nls"
	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {	
	einstall destdir=${D} graphicsdir=${D}/usr/share/pixmaps || die "einstall failed"
	dodoc AUTHORS Changelog COPYING CREDITS INSTALL README TODO
}

pkg_postinstall() {
	./postinstall
}
