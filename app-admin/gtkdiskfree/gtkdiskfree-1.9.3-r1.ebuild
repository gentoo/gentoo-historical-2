# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/gtkdiskfree/gtkdiskfree-1.9.3-r1.ebuild,v 1.3 2005/09/30 18:11:33 corsair Exp $

inherit eutils

DESCRIPTION="Graphical tool to show free disk space"
HOMEPAGE="http://gtkdiskfree.tuxfamily.org/"
SRC_URI="http://gtkdiskfree.tuxfamily.org/src_tgz/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 ~x86"
IUSE="nls"

DEPEND=">=x11-libs/gtk+-2
	>=dev-libs/glib-2
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-tempfile.patch #104565
	epatch "${FILESDIR}"/${PV}-makefile-DESTDIR.patch
}

src_compile() {
	econf $(use_enable nls) || die
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}
