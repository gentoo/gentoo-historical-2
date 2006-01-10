# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/startup-notification/startup-notification-0.8.ebuild,v 1.13 2006/01/10 06:02:42 mr_bones_ Exp $

inherit gnome.org

DESCRIPTION="Application startup notification and feedback library"
HOMEPAGE="http://www.freedesktop.org/software/startup-notification/"

LICENSE="LGPL-2 BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND="|| ( (	x11-libs/libX11
		x11-libs/libSM )
	virtual/x11 )"

DEPEND="${RDEPEND}
	|| ( x11-proto/xproto virtual/x11 )"

src_install() {

	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog INSTALL NEWS README doc/startup-notification.txt

}
