# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/rotix/rotix-0.83.ebuild,v 1.1 2002/12/20 23:37:01 avenj Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Rotix allows you to generate rotational obfuscations."
HOMEPAGE="http://elektron.its.tudelft.nl/~hemmin98/rotix.html"
SRC_URI="http://elektron.its.tudelft.nl/~hemmin98/rotix_releases/${P}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE="nls"

RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	local myconf

	use nls && myconf="--i18n=1"

	econf ${myconf} || die
	
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}
