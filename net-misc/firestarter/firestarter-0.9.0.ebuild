# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/firestarter/firestarter-0.9.0.ebuild,v 1.8 2002/10/20 18:52:19 vapier Exp $

IUSE="nls"

#MY_P=firestarter-${PV}
S=${WORKDIR}/${P}
DESCRIPTION="Gui for firewalls (iptables & ipchains), and a firewall monitor."
SRC_URI="mirror://sourceforge/firestarter/${P}.tar.gz"
HOMEPAGE="http://firestarter.sf.net"
LICENSE="GPL-2"

DEPEND="x11-libs/gtk+
	gnome-base/libgnomeui
	gnome-base/libgnome	
	sys-apps/iptables
	nls? ( sys-devel/gettext )"
SLOT="0"
KEYWORDS="x86 ppc sparc sparc64"

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
	dodoc AUTHORS Changelog README TODO

}

pkg_postinstall() {
	./postinstall
}
