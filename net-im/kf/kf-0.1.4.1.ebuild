# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/kf/kf-0.1.4.1.ebuild,v 1.3 2004/06/19 06:18:28 weeve Exp $

inherit eutils

DESCRIPTION="kf is a simple Jabber messenger."
HOMEPAGE="http://www.habazie.rams.pl/kf/"
SRC_URI="http://www.habazie.rams.pl/kf/files/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="spell"
DEPEND=">=x11-libs/gtk+-2
	>=net-libs/loudmouth-0.16
	>=gnome-base/libglade-2
	spell? ( >=app-text/gtkspell-2.0.4 )"
KEYWORDS="~x86 ~ppc ~sparc"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-gtkspell-2.0.4-compatibility.diff
}

src_compile() {
	econf `use_enable spell gtkspell` || die 'econf failed'
	emake || die 'emake failed'
}

src_install() {
	make install DESTDIR=${D} || die 'make install failed'
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README
}
