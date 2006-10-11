# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xsri/xsri-2.1.0.ebuild,v 1.4 2006/10/11 11:44:37 nelchael Exp $

inherit base rpm

DESCRIPTION="The xsri wallpaper setter from RedHat"
HOMEPAGE="http://fedora.redhat.com/"
SRC_URI="http://download.fedora.redhat.com/pub/fedora/linux/core/4/SRPMS/${P}-9.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="=x11-libs/gtk+-2*
	dev-util/pkgconfig"

src_install() {
	base_src_install "$@"
	dodoc AUTHORS README NEWS
}
