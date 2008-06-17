# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/sylpheed/sylpheed-2.4.8.ebuild,v 1.3 2008/06/17 16:30:49 jer Exp $

inherit autotools eutils

IUSE="crypt ipv6 ldap nls pda spell ssl xface"

DESCRIPTION="A lightweight email client and newsreader"
HOMEPAGE="http://sylpheed.sraoss.jp/"
SRC_URI="http://sylpheed.sraoss.jp/${PN}/v${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="~alpha ~amd64 hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"

COMMON_DEPEND=">=x11-libs/gtk+-2.4
	nls? ( >=sys-devel/gettext-0.12.1 )
	crypt? ( >=app-crypt/gpgme-0.4.5 )
	ldap? ( >=net-nds/openldap-2.0.11 )
	pda? ( app-pda/jpilot )
	spell? ( app-text/gtkspell )
	ssl? ( dev-libs/openssl )"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
	xface? ( >=media-libs/compface-1.4 )"
RDEPEND="${COMMON_DEPEND}
	app-misc/mime-types
	x11-misc/shared-mime-info"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-2.*.diff

	mkdir m4 # bug 219341

	use crypt || cp ac/missing/gpgme.m4 ac

	AT_M4DIR="ac" eautoreconf
}

src_compile() {

	local htmldir=/usr/share/doc/${PF}/html

	econf \
		$(use_enable crypt gpgme) \
		$(use_enable ipv6) \
		$(use_enable ldap) \
		$(use_enable nls) \
		$(use_enable pda jpilot) \
		$(use_enable spell gtkspell) \
		$(use_enable ssl) \
		$(use_enable xface compface) \
		--with-manualdir=${htmldir}/manual \
		--with-faqdir=${htmldir}/faq \
		|| die
	emake || die

}

src_install() {

	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog* NEWS* README* TODO*
	doicon *.png
	domenu *.desktop

}
