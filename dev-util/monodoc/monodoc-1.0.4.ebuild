# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/monodoc/monodoc-1.0.4.ebuild,v 1.2 2005/02/19 19:09:30 dholm Exp $

inherit mono

DESCRIPTION="Documentation for mono's .Net class library"
HOMEPAGE="http://www.go-mono.com"
SRC_URI="http://www.go-mono.com/archive/${PV}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""
DEPEND=">=dev-dotnet/mono-${PV}
		>=dev-dotnet/gtk-sharp-${PV}"

src_unpack() {
	if [ ! -f ${ROOT}/usr/lib/mono/gtk-sharp/gtkhtml-sharp.dll ]
	then
		echo
		eerror "Support for gtkhtml missing from gtk-sharp!"
		eerror "Please re-emerge gtk-sharp with 'gtkhtml' in USE,"
		eerror "then emerge monodoc."
		die "gtkhtml support missing from gtk-sharp"
	fi
	unpack ${A}
}

src_compile() {
	econf || die
	MAKEOPTS="${MAKEOPTS} -j1"
	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die
}
