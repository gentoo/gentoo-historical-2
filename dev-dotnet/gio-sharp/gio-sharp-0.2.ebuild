# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gio-sharp/gio-sharp-0.2.ebuild,v 1.1 2011/02/27 19:11:26 ssuominen Exp $

EAPI=2
inherit autotools mono

DESCRIPTION="GIO API C# binding"
HOMEPAGE="http://github.com/mono/gio-sharp"
SRC_URI="http://github.com/mono/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-dotnet/glib-sharp-2.12
	>=dev-dotnet/gtk-sharp-gapi-2.12
	>=dev-libs/glib-2.22"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	mv *-${PN}-* "${S}"
}

src_prepare() {
	sed -i -e '/autoreconf/d' autogen-generic.sh || die
	NOCONFIGURE=1 ./autogen-2.22.sh || die

	eautoreconf
}

src_compile() {
	emake -j1 || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README
}
