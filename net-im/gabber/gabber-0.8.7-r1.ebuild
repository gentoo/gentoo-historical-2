# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Author Frederic Brin <duckx@libertysurf.fr>, Maintainer: Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-im/gabber/gabber-0.8.7-r1.ebuild,v 1.5 2002/06/08 15:38:09 spider Exp $

S=${WORKDIR}/${P}
DESCRIPTION="The GNOME Jabber Client"
SRC_URI="mirror://sourceforge/gabber/${P}.tar.gz"
HOMEPAGE="http://gabber.sourceforge.net"
SLOT="0"
DEPEND=">=gnome-base/gnome-libs-1.4.1.2-r1
	( >=gnome-base/libglade-0.17-r1
	  <gnome-base/libglade-1.99.0 )
	>=gnome-extra/gal-0.13
	>=gnome-extra/gnomemm-1.2.0
	( >=x11-libs/gtkmm-1.2.5
	  <x11-libs/gtkmm-1.3.0 )
   	ssl? ( >=dev-libs/openssl-0.9.6 )
   	crypt? ( >=app-crypt/gnupg-1.0.5 )"

RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	local myconf

	use ssl \
		|| myconf="${myconf} --disable-ssl"

	use nls \
		|| myconf="${myconf} --disable-nls"

	econf ${myconf} || die
	emake || die
}

src_install() {
	einstall || die
}

