# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/firestarter/firestarter-0.8.3.ebuild,v 1.6 2003/09/07 00:10:32 msterret Exp $

IUSE="nls"

S=${WORKDIR}/${P}
DESCRIPTION="Gui for firewalls (iptables & ipchains), and a firewall monitor."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://firestarter.sf.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc"

RDEPEND="=x11-libs/gtk+-1.2*
	>=gnome-base/gnome-libs-1.4.1.4
	<gnome-base/gnome-panel-2
	net-firewall/iptables"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_compile() {

	local myconf
	use nls \
		&& myconf="${myconf} --enable-nls" \
		|| myconf="${myconf} --disable-nls"

	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {

	einstall \
		destdir=${D} \
		graphicsdir=${D}/usr/share/pixmaps || die "einstall failed"

	dodoc AUTHORS Changelog README TODO

}

pkg_postinstall() {
	./postinstall
}
