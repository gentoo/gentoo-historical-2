# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/sound-theme-freedesktop/sound-theme-freedesktop-0.2.ebuild,v 1.12 2009/04/28 11:51:18 armin76 Exp $

DESCRIPTION="Default freedesktop.org sound theme following the XDG theming specification"
HOMEPAGE="http://www.freedesktop.org/wiki/Specifications/sound-theme-spec"
SRC_URI="http://people.freedesktop.org/~mccann/dist/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2 CCPL-Attribution-3.0 CCPL-Attribution-ShareAlike-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND=">=dev-util/intltool-0.40"

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"
	dodoc AUTHORS ChangeLog NEWS README || die "Installation of documentation failed"
}
