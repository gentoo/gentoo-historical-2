# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/matchbox/matchbox-0.7.1.ebuild,v 1.6 2005/07/01 22:06:03 josejx Exp $

IUSE="jpeg png nls debug"

DESCRIPTION="Light weight WM designed for use on PDA computers"
HOMEPAGE="http://projects.o-hand.com/matchbox/"
SRC_URI="http://handhelds.org/~mallum/downloadables/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="ppc x86"

RDEPEND="virtual/x11
	dev-libs/expat
	x11-libs/startup-notification
	x11-libs/libxsettings-client
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )"

DEPEND="${RDEPEND}
	sys-devel/libtool"

use debug && RESTRICT="nostrip"

src_compile() {
	local myconf
	myconf="${myconf} --enable-dnotify"
	myconf="${myconf} --enable-expat"
	myconf="${myconf} --enable-sn"
	myconf="${myconf} --enable-xsettings"
	use nls && myconf="${myconf} --enable-nls"
	use jpeg && myconf="${myconf} --enable-jpg"
	use png || myconf="${myconf} --disable-png"
	use debug && myconf="${myconf} --enable-debug"

	econf ${myconf} || die "Configuration failed"
	emake || die "Make feiled"
}

src_install() {
	einstall || die "Install failed"
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS \
	      README RELEASE-NOTES-0.7 TODO
}
