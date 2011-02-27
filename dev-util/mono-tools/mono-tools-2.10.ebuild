# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/mono-tools/mono-tools-2.10.ebuild,v 1.1 2011/02/27 13:30:01 pacho Exp $

EAPI=2

inherit go-mono mono autotools

DESCRIPTION="Set of useful Mono related utilities"
HOMEPAGE="http://www.mono-project.com/"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="webkit gtkhtml +xulrunner"

RDEPEND="=virtual/monodoc-${GO_MONO_REL_PV}*
	>=dev-dotnet/gtk-sharp-2.12.6:2
	>=dev-dotnet/glade-sharp-2.12.6:2
	>=dev-dotnet/gconf-sharp-2:2
	gtkhtml? ( >=dev-dotnet/gtkhtml-sharp-2.24.0:2 )
	webkit? ( >=dev-dotnet/webkit-sharp-0.2-r1 )
	xulrunner? ( >=dev-dotnet/gluezilla-2.6 )
	"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.19"

PATCHES=( "${FILESDIR}/${PN}-2.8-html-renderer-fixes.patch" )

#Fails parallel make.
MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	if ! use webkit && ! use gtkhtml && ! use xulrunner
	then
		die "You must USE either webkit, gtkhtml or xulrunner"
	fi
}

src_prepare() {
	go-mono_src_prepare

	# Stop getting ACLOCAL_FLAGS command not found problem like bug #298813
	sed -i -e '/ACLOCAL_FLAGS/d' Makefile.am

	eautoreconf
}

src_configure() {
	econf	--disable-dependency-tracking \
		--disable-gecko \
		$(use_enable gtkhtml) \
		$(use_enable webkit) \
		$(use_enable xulrunner monowebbrowser) \
		|| die "configure failed"
}
