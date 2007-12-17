# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/mlterm/mlterm-2.9.4.ebuild,v 1.1 2007/12/17 17:10:56 matsuu Exp $

inherit eutils flag-o-matic

IUSE="truetype gtk imlib bidi nls uim scim"
#IUSE="${IUSE} m17n-lib iiimf"

DESCRIPTION="A multi-lingual terminal emulator"
HOMEPAGE="http://mlterm.sourceforge.net/"
SRC_URI="mirror://sourceforge/mlterm/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
LICENSE="BSD"

RDEPEND="gtk? ( >=x11-libs/gtk+-2 )
	!gtk? ( imlib? ( >=media-libs/imlib-1.9.14 ) )
	truetype? ( =media-libs/freetype-2* )
	bidi? ( >=dev-libs/fribidi-0.10.4 )
	nls? ( sys-devel/gettext )
	uim? ( >=app-i18n/uim-0.3.4.2 )
	scim? ( || ( >=app-i18n/scim-1.4 app-i18n/scim-cvs ) )
	virtual/utempter
	x11-libs/libX11
	x11-libs/libICE
	x11-libs/libSM"
DEPEND="${RDEPEND}"
#	m17n-lib? ( >=dev-libs/m17n-lib-1.2.0 )

src_unpack() {
	unpack ${A}
	cd "${S}"/xwindow
	epatch "${FILESDIR}"/${PN}-2.9.1-gentoo.diff
	epatch "${FILESDIR}"/${PN}-2.9.3-asneeded.diff
}

src_compile() {
	local myconf imagelib

	if use gtk ; then
		imagelib="gdk-pixbuf"
	elif use imlib ; then
		imagelib="imlib"
	fi

	use gtk || myconf="${myconf} --with-tools=mlclient,mlcc"

	# m17n-lib, and iiimf aren't stable enough
	#myconf="${myconf} $(use_enable iiimf) $(use_enable m17n-lib m17nlib)"

	append-ldflags $(bindnow-flags)

	econf --enable-utmp \
		$(use_enable truetype anti-alias) \
		$(use_enable bidi fribidi) \
		$(use_enable nls) \
		$(use_enable uim) \
		$(use_enable scim) \
		--with-imagelib="${imagelib}" \
		${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die

	dodoc ChangeLog LICENCE README

	docinto ja
	dodoc doc/ja/*
	docinto en
	dodoc doc/en/*
}
