# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/podsleuth/podsleuth-0.6.1.ebuild,v 1.1 2008/01/27 15:54:21 drac Exp $

inherit mono

DESCRIPTION="a tool to discover detailed model information about an Apple (TM) iPod (TM)."
HOMEPAGE="http://banshee-project.org/PodSleuth"
SRC_URI="http://banshee-project.org/files/${PN}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-lang/mono-1.1.10
	dev-dotnet/dbus-glib-sharp
	>=sys-apps/hal-0.5.6
	sys-apps/sg3_utils"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf --with-hal-callouts-dir=/usr/libexec
	emake -j1 || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README
}
