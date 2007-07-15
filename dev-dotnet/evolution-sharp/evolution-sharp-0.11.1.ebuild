# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/evolution-sharp/evolution-sharp-0.11.1.ebuild,v 1.5 2007/07/15 02:54:24 mr_bones_ Exp $

inherit mono versionator eutils
DESCRIPTION="Mono bindings for Evolution"
HOMEPAGE="http://www.gnome.org/projects/beagle/"
SRC_URI="mirror://gnome/sources/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE=""

DEPEND=">=gnome-extra/evolution-data-server-1.2
	>=dev-lang/mono-1.0
	>=dev-dotnet/gtk-sharp-2.4.0
	>=mail-client/evolution-2.2.0"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Use correct libdir in pkgconfig files
	sed -i -e 's:^libdir.*:libdir=@libdir@:' \
		-e 's:^prefix=:exec_prefix=:' \
		-e 's:prefix)/lib:libdir):' \
		${S}/*.pc.in || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog MAINTAINERS NEWS README
}
