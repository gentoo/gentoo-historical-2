# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/sound-theme-freedesktop/sound-theme-freedesktop-0.2.ebuild,v 1.3 2009/02/27 18:37:58 josejx Exp $

DESCRIPTION="Default freedesktop.org sound theme following the XDG theming specification"
HOMEPAGE="http://www.freedesktop.org/wiki/Specifications/sound-theme-spec"
SRC_URI="http://people.freedesktop.org/~mccann/dist/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2 CCPL-Attribution-3.0 CCPL-Attribution-ShareAlike-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE=""

RDEPEND=""
DEPEND=">=dev-util/intltool-0.40"

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"
	dodoc AUTHORS ChangeLog NEWS README || die "Installation of documentation failed"
}
