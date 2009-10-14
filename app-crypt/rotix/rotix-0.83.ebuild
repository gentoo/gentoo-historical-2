# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/rotix/rotix-0.83.ebuild,v 1.13 2009/10/14 00:58:35 halcy0n Exp $

inherit eutils

DESCRIPTION="Rotix allows you to generate rotational obfuscations."
HOMEPAGE="http://elektron.its.tudelft.nl/~hemmin98/rotix.html"
SRC_URI="http://elektron.its.tudelft.nl/~hemmin98/rotix_releases/${P}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc amd64 ia64"
IUSE="nls"

RDEPEND="nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-respect-CFLAGS-and-dont-strip.patch
}

src_compile() {
	local myconf
	use nls && myconf="--i18n=1"
	econf ${myconf} || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
