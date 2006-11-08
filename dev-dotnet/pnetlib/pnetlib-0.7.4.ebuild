# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/pnetlib/pnetlib-0.7.4.ebuild,v 1.4 2006/11/08 04:02:28 dang Exp $

inherit autotools eutils

DESCRIPTION="Portable.NET C# library"
HOMEPAGE="http://www.dotgnu.org/"
SRC_URI="http://www.southern-storm.com.au/download/${P}.tar.gz"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ia64 ppc ~ppc64 ~x86"
IUSE="doc truetype X"

DEPEND="=dev-dotnet/pnet-${PV}*
	X? ( || (
	( x11-libs/libSM
	x11-libs/libXft )
	virtual/x11 ) )
	truetype? ( virtual/xft )
	=sys-devel/automake-1.4_p6"

RDEPEND="=dev-dotnet/pnet-${PV}*
	X? ( || (
	( x11-libs/libSM
	x11-libs/libXft )
	virtual/x11 ) )
	truetype? ( virtual/xft )"

src_unpack() {
	unpack ${A}
	cd ${S}

	# patch configure.in to detect renamed resgen.pnet ; bug #39369
	epatch ${FILESDIR}/0.7.0-resgen.patch

	eautoreconf || die "eautoreconf failed"
}

src_compile() {
	local lib_profile="default1.1"

	elog "Using profile: ${lib_profile}"
	econf --with-profile=${lib_profile} \
		$(use_enable truetype xft) || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog HACKING NEWS README

	use doc && dodoc doc/*.txt
	use doc && dohtml doc/*.html
}
