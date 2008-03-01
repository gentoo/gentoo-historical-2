# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/heap-buddy/heap-buddy-0.1.ebuild,v 1.4 2008/03/01 23:20:01 compnerd Exp $

inherit mono

DESCRIPTION="Heap profile for use with the mono .NET runtime"
HOMEPAGE="http://www.mono-project.com/"
SRC_URI="http://www.go-mono.com/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/mono-1.1.10
	>=dev-libs/glib-2.0"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.20"

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README
}
