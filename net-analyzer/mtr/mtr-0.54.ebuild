# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/mtr/mtr-0.54.ebuild,v 1.9 2004/10/04 22:59:47 pvdabeel Exp $

IUSE="gtk"

DESCRIPTION="My TraceRoute. Excellent network diagnostic tool."
SRC_URI="ftp://ftp.bitwizard.nl/mtr/${P}.tar.gz"
HOMEPAGE="http://www.bitwizard.nl/mtr/"

DEPEND=">=sys-libs/ncurses-5.2
	gtk? ( =x11-libs/gtk+-1.2* )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc hppa alpha"

src_compile() {
	local myconf
	use gtk || myconf="${myconf} --without-gtk"

	econf ${myconf} || die
	emake || die
}

src_install() {
	# this binary is universal. ie: it does both console and gtk.
	make DESTDIR=${D} sbindir=/usr/bin install || die
	dodoc AUTHORS COPYING ChangeLog FORMATS NEWS README SECURITY TODO
}
