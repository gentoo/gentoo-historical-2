# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/gpsui/gpsui-2.2.ebuild,v 1.4 2003/03/28 10:27:38 pvdabeel Exp $

DESCRIPTION="GUI program for managing running processes"
HOMEPAGE="http://gpsui.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="nls"

S="${WORKDIR}/${PN}"

DEPEND="=x11-libs/gtk+-1.2*
	=gnome-base/gnome-libs-1.4*
	nls? ( sys-devel/gettext )"

src_compile() {
	local myconf=""
	use nls \
		&& myconf="--enable-nls" \
		|| myconf="--disable-nls"
	econf ${myconf}

	emake || die "Compilation failed"
}

src_install() {
	einstall
	dodoc ABOUT-NLS AUTHORS ChangeLog COPYING README
}
