# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/blam/blam-1.0.54.ebuild,v 1.1 2004/08/03 02:00:26 latexer Exp $

inherit mono

DESCRIPTION="A RSS aggregator written in C#"
HOMEPAGE="http://micke.hallendal.net/"
SRC_URI="http://ftp.imendio.com/pub/imendio/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""
DEPEND=">=dev-dotnet/mono-1.0
		>=x11-libs/gtk-sharp-1.0
		>=gnome-base/gconf-2.4"

src_compile() {
	econf || die
	emake -j1 || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
}
