# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/sylpheed/sylpheed-1.0.4.ebuild,v 1.8 2005/03/31 13:20:52 hattya Exp $

inherit eutils

IUSE="crypt gnome imlib ipv6 ldap nls pda ssl xface"

DESCRIPTION="A lightweight email client and newsreader"
HOMEPAGE="http://sylpheed.good-day.net/"
SRC_URI="http://sylpheed.good-day.net/${PN}/v${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
SLOT="0"

PROVIDE="virtual/sylpheed"

DEPEND="=x11-libs/gtk+-1.2*
	!amd64? ( nls? ( >=sys-devel/gettext-0.12.1 ) )
	crypt? ( >=app-crypt/gpgme-0.4.5 )
	gnome? ( media-libs/gdk-pixbuf )
	imlib? ( media-libs/imlib )
	ldap? ( >=net-nds/openldap-2.0.11 )
	pda? ( app-pda/jpilot )
	ssl? ( dev-libs/openssl )
	xface? ( >=media-libs/compface-1.4 )"
RDEPEND="${DEPEND}
	app-misc/mime-types
	x11-misc/shared-mime-info"

src_unpack() {

	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${PN}-namespace.diff
	epatch ${FILESDIR}/${PN}-procmime.diff

}

src_compile() {

	econf \
		`use_enable nls` \
		`use_enable ssl` \
		`use_enable crypt gpgme` \
		`use_enable pda jpilot` \
		`use_enable ldap` \
		`use_enable ipv6` \
		`use_enable imlib` \
		`use_enable gnome gdk-pixbuf` \
		`use_enable xface compface` \
		|| die

	emake || die

}

src_install() {

	einstall

	dodir /usr/share/pixmaps
	insinto /usr/share/pixmaps
	doins *.png

	if use gnome
	then
		dodir /usr/share/gnome/apps/Internet
		insinto /usr/share/gnome/apps/Internet
		doins sylpheed.desktop
	fi

	dodoc [A-Z][A-Z]* ChangeLog*

}
