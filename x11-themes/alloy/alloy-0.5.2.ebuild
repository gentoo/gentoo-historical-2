# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/alloy/alloy-0.5.2.ebuild,v 1.3 2004/08/30 19:44:41 pvdabeel Exp $

inherit kde eutils

DESCRIPTION="A neat KDE style based on the Java Alloy Look&Feel from Incors (http://www.incors.com)."
HOMEPAGE="http://www.kde-look.org/content/show.php?content=10605"
SRC_URI="http://www.kde-look.org/content/files/10605-${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ppc ~alpha ~amd64"
IUSE=""

DEPEND=">=kde-base/kdebase-3.2
	>=x11-libs/qt-3.3.0"
RDEPEND=">=kde-base/kdebase-3.2
	>=x11-libs/qt-3.3.0"
need-kde 3.2

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/remove-extra-semicolon.patch
}
