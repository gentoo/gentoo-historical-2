# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xdg-utils/xdg-utils-1.0.2.ebuild,v 1.5 2007/09/22 14:42:53 dertobi123 Exp $

DESCRIPTION="Portland utils for cross-platform/cross-toolkit/cross-desktop interoperability"
HOMEPAGE="http://portland.freedesktop.org/wiki/Portland"
SRC_URI="http://portland.freedesktop.org/download/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE="doc"

RESTRICT="test"

RDEPEND="x11-apps/xprop"
DEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc ChangeLog README RELEASE_NOTES TODO
	newdoc scripts/README README.scripts
	use doc && dohtml -r scripts/html
}
