# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xdg-utils/xdg-utils-1.0.1.ebuild,v 1.9 2007/06/27 06:05:00 corsair Exp $

MY_P="${P/_}"

DESCRIPTION="Portland utils for cross-platform/cross-toolkit/cross-desktop interoperability"
HOMEPAGE="http://portland.freedesktop.org/wiki/Portland"
SRC_URI="http://portland.freedesktop.org/download/${MY_P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RESTRICT="test"

DEPEND=""
RDEPEND="x11-apps/xprop"

S="${WORKDIR}/${MY_P}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README TODO RELEASE_NOTES
}
