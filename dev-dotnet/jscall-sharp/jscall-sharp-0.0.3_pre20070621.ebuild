# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/jscall-sharp/jscall-sharp-0.0.3_pre20070621.ebuild,v 1.4 2008/05/30 23:15:00 jurek Exp $

inherit mono eutils

DESCRIPTION="A simple JavaScript bridge for Gecko#"
HOMEPAGE="http://www.go-mono.com/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( =www-client/mozilla-firefox-2*
			=www-client/seamonkey-1* )
		>=dev-lang/mono-1.1.9
		>=dev-dotnet/gtk-sharp-2.4
		>=dev-dotnet/gecko-sharp-0.10
		dev-util/pkgconfig"

src_unpack()
{
	unpack ${A}
	cd "${S}"

	einfo "Running autogen..."
	./autogen.sh || die "autogen failed"
}

src_install()
{
	make GACUTIL_FLAGS="/root "${D}"/usr/$(get_libdir) \
		/gacdir /usr/$(get_libdir) /package ${PN}-0.0.3" \
		DESTDIR="${D}" install || die

	dodoc ChangeLog README AUTHORS
}
