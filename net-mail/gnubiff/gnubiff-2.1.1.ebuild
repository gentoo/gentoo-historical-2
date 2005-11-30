# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/gnubiff/gnubiff-2.1.1.ebuild,v 1.1 2005/03/07 12:57:56 nakano Exp $

inherit eutils

DESCRIPTION="A mail notification program"
HOMEPAGE="http://gnubiff.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gnome password"

RDEPEND="virtual/libc
	>=x11-libs/gtk+-2.4
	gnome? ( >=gnome-base/libgnome-2.2
		>=gnome-base/libgnomeui-2.2 )"

DEPEND="${RDEPEND}
	gnome? ( dev-util/pkgconfig )"

src_compile() {
	local myconf

	if use gnome; then
		myconf="${myconf} --prefix=`pkg-config libpanelapplet-2.0 --variable=prefix`"
	else
		myconf="${myconf} --disable-gnome"
	fi

	if use password; then
		einfo "generating random password"
		myconf="${myconf} --with-password --with-password-string=${RANDOM}${RANDOM}${RANDOM}${RANDOM}"
	fi

	econf ${myconf} || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc ABOUT-NLS AUTHORS ChangeLog COPYING INSTALL NEWS README THANKS TODO
}
