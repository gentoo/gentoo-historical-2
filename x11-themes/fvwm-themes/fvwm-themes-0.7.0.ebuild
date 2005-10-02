# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/fvwm-themes/fvwm-themes-0.7.0.ebuild,v 1.10 2005/10/02 19:35:32 agriffis Exp $

IUSE="gnome"

inherit eutils

DESCRIPTION="A configuration framework for the fvwm window manager"
HOMEPAGE="http://fvwm-themes.sourceforge.net/"
SRC_URI="mirror://sourceforge/fvwm-themes/${P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ia64 ppc ~sparc x86"
SLOT="0"

DEPEND=">=x11-wm/fvwm-2.5.8
	gnome? ( media-gfx/imagemagick )"
RDEPEND="x11-wm/fvwm"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	local myconf

	use gnome && myconf="--enable-gnome-icons"

	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}


src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
}

pkg_postinst() {
	einfo
	einfo "Configuring ${P}"
	einfo

	fvwm-themes-config --site --reset
	fvwm-themes-menuapp --site --build-menus --remove-popup

	use gnome && fvwm-themes-images --ft-install --gnome
}
