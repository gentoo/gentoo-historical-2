# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/smuxi/smuxi-0.6.3.ebuild,v 1.5 2009/04/05 21:20:02 loki_val Exp $

EAPI="2"

inherit base  mono

DESCRIPTION="A flexible, irssi-like and user-friendly IRC client for the Gnome Desktop."
HOMEPAGE="http://www.smuxi.org/page/Download"
SRC_URI="http://smuxi.meebey.net/jaws/data/files/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
LICENSE="|| ( GPL-2 GPL-3 )"

RDEPEND=">=dev-lang/mono-2.0
	>=dev-dotnet/smartirc4net-0.4.5.1
	>=dev-dotnet/nini-1.1.0-r2
	>=dev-dotnet/log4net-1.2.10-r2
	>=dev-dotnet/gtk-sharp-2.12
	>=dev-dotnet/gnome-sharp-2.12
	>=dev-dotnet/gconf-sharp-2.12
	>=dev-dotnet/glade-sharp-2.12
	>=dev-dotnet/glib-sharp-2.12"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.25
	>=sys-devel/gettext-0.17
	>=dev-util/pkgconfig-0.23"

PATCHES=( "${FILESDIR}/${P}-mono-2.2.patch"
	"${FILESDIR}/${P}-infinite-loop.patch" )

src_configure() {
	econf	--disable-dependency-tracking	\
		--enable-engine-irc		\
		--enable-frontend-gnome
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc FEATURES TODO README || die "dodoc failed"
}
