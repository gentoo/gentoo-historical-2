# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/ml-pnet/ml-pnet-0.7.4.ebuild,v 1.3 2006/11/08 09:00:26 opfer Exp $

DESCRIPTION="Mono C# libraries for Portable.NET"
HOMEPAGE="http://www.dotgnu.org/"
SRC_URI="http://www.southern-storm.com.au/download/${P}.tar.gz"

LICENSE="|| ( GPL-2 X11 )"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 x86"
IUSE=""

DEPEND="=dev-dotnet/pnetlib-${PV}*"

src_compile() {
	local lib_profile="framework1.1"
	elog "Using profile: ${lib_profile}"

	econf --with-profile=${lib_profile} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
