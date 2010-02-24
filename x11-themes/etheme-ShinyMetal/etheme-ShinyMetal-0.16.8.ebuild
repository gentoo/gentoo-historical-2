# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/etheme-ShinyMetal/etheme-ShinyMetal-0.16.8.ebuild,v 1.2 2010/02/24 14:50:28 ssuominen Exp $

MY_PN="${PN/etheme-/e16-theme-}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="${MY_PN} theme for Enlightenment 16.7"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="mirror://sourceforge/enlightenment/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sh sparc x86"
IUSE=""

DEPEND=">=x11-wm/enlightenment-0.16.7_pre3"

S=${WORKDIR}/${MY_P}

src_compile() {
	econf --enable-fsstd || die
	emake || die
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README
}
