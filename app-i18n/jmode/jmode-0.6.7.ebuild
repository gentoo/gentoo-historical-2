# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/jmode/jmode-0.6.7.ebuild,v 1.3 2004/06/24 21:48:00 agriffis Exp $

IUSE="gnome"

DESCRIPTION="Jmode is a Japanese IME supporting Anthy"
HOMEPAGE="http://anthy.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/anthy/5467/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"

DEPEND="=x11-libs/gtk+-1.2*
	app-i18n/anthy
	gnome? ( gnome-base/gnome-panel )"

src_compile() {

	# --with-skk and --with-engine=anthy are exclusive
	econf `use_with gnome` \
		--with-engine=anthy || die
	emake CPPFLAGS="${CPPFLAGS} -DCONF_DIR=\\\"/etc/jmode/\\\"" || die
}

src_install () {

	einstall pkgdatadir=${D}/etc/jmode || die

	dodoc AUTHORS ChangeLog INSTALL NEWS README
}
