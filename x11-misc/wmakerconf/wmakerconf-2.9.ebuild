# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/wmakerconf/wmakerconf-2.9.ebuild,v 1.17 2004/06/24 22:36:27 agriffis Exp $

IUSE="nls gnome imlib perl"

DESCRIPTION="X based config tool for the windowmaker X windowmanager."
SRC_URI="http://www.windowmaker.org/pub/contrib/source/wmakerconf/${P}.tar.bz2"
# Homepage appears not to be up anymore
HOMEPAGE="http://ulli.on.openave.net/wmakerconf/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-*"

DEPEND="=x11-libs/gtk+-1.2*
	x11-wm/windowmaker
	gnome? ( =gnome-base/gnome-libs-1.4* )
	imlib? ( media-libs/imlib )"


RDEPEND="nls? ( sys-devel/gettext )
	perl? ( dev-lang/perl
		net-misc/wget )"

src_compile() {

	local myconf

	use nls	|| myconf="${myconf} --disable-nls"

	use imlib || myconf="${myconf} --disable-imlibtest"

	use gnome || myconf="${myconf} --without-gnome"

	./configure \
		--prefix=/usr \
		--host=${CHOST} \
		--sysconfdir=/etc \
		${myconf} || die
	emake || die

}

src_install() {

	make \
		prefix=${D}/usr \
		GNOMEDIR=${D}/usr/share/gnome/apps/Settings \
		install || die

	dodoc README MANUAL AUTHORS TODO COPYING ChangeLog
		dohtml -r .
}
