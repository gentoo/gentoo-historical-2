# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-audio/gnome-audio-2.0.0.ebuild,v 1.11 2007/11/21 11:12:52 lu_zero Exp $

inherit gnome2

DESCRIPTION="Gnome Desktop Sound Effects Package"
HOMEPAGE="http://www.gnome.org/"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="alpha amd64 hppa ia64 ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	return
}

src_install() {
	make prefix=${D}/usr install || die "installed failed"
	dodoc README
}
