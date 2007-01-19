# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/gtkcdlabel/gtkcdlabel-1.0_pre7-r1.ebuild,v 1.3 2007/01/19 13:43:33 masterdriverz Exp $

inherit flag-o-matic

MY_P=${P/_}
DESCRIPTION="A GTK+ frontend to cdlabelgen for easy and fast cd cover creation"
HOMEPAGE="http://gtkcdlabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/gtkcdlabel/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~x86 ~ppc ~sparc ~amd64"

RDEPEND=">=app-cdr/cdlabelgen-2.3.0
	>=x11-libs/gtk+-2
	>=gnome-base/libglade-2
	>=gnome-base/libgnomeui-2
	>=app-text/ggv-2.8"

DEPEND="${RDEPEND}
	sys-apps/gawk
	dev-util/pkgconfig
	sys-devel/gcc"

S=${WORKDIR}/${MY_P}

src_compile() {

	append-ldflags -export-dynamic
	export LDFLAGS

	econf || die "configure problem"
	emake || die "compile problem"
}

src_install() {
	make DESTDIR=${D} install || die "install problem"
	dodoc AUTHORS ChangeLog README
}
