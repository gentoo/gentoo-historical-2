# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/monodoc/monodoc-0.18.ebuild,v 1.2 2004/07/09 00:38:49 mr_bones_ Exp $

inherit mono

DESCRIPTION="Documentation for mono's .Net class library"
HOMEPAGE="http://www.go-mono.com"
SRC_URI="http://www.go-mono.com/archive/rc/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""
DEPEND=">=dev-dotnet/mono-0.97
		>=x11-libs/gtk-sharp-0.99"

src_compile() {
	econf || die
	MAKEOPTS="${MAKEOPTS} -j1"
	emake || {
		echo
		ewarn "If for some reason this fails, try adding 'gtkhtml' to your USE variables, re-emerge gtk-sharp, then emerge monodoc"
		die "make failed"
	}
}

src_install() {
	make DESTDIR=${D} install || die
}
