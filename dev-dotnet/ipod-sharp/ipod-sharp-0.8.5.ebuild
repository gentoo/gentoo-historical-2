# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/ipod-sharp/ipod-sharp-0.8.5.ebuild,v 1.2 2010/05/18 14:49:59 phajdan.jr Exp $

EAPI=2
inherit eutils mono

DESCRIPTION="ipod-sharp provides high-level feature support for Apple's iPod and binds libipoddevice."
HOMEPAGE="http://banshee-project.org/Ipod-sharp"
SRC_URI="http://banshee-project.org/files/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="doc"

RDEPEND=">=dev-lang/mono-2
	dev-dotnet/dbus-glib-sharp
	>=dev-dotnet/podsleuth-0.6.4
	>=dev-dotnet/gtk-sharp-2.12"
DEPEND="${RDEPEND}
	doc? ( >=virtual/monodoc-1.1.8 )
	dev-util/pkgconfig"

src_configure() {
	econf $(use_enable doc docs)
}

src_compile() {
	emake -j1 || die "emake failed."
}
src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README
	mono_multilib_comply
}
