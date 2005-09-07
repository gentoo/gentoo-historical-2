# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/gpsui/gpsui-2.2.ebuild,v 1.16 2005/09/07 03:44:39 metalgod Exp $

DESCRIPTION="GUI program for managing running processes"
HOMEPAGE="http://gpsui.sourceforge.net/"
SRC_URI="mirror://sourceforge/gpsui/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 x86"
IUSE="nls"

DEPEND="=x11-libs/gtk+-1.2*
	=gnome-base/gnome-libs-1.4*
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/${PN}"

src_compile() {
	econf $(use_enable nls) || die "econf failed"
	emake || die "Compilation failed"
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog README
}
