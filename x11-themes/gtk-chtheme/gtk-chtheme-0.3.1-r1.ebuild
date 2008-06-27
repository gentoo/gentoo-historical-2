# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-chtheme/gtk-chtheme-0.3.1-r1.ebuild,v 1.4 2008/06/27 13:25:11 ranger Exp $

inherit toolchain-funcs

DESCRIPTION="GTK-2.0 Theme Switcher"
HOMEPAGE="http://plasmasturm.org/programs/gtk-chtheme/"
SRC_URI="http://plasmasturm.org/programs/gtk-chtheme/${P}.tar.bz2"

IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~ppc ppc64 ~sparc x86"
LICENSE="GPL-2"

RDEPEND=">=x11-libs/gtk+-2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}

	# QA: stop Makefile from stripping the binaries
	sed -i -e "s:strip:true:" "${S}"/Makefile || die "sed failed."
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
