# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/crystal/crystal-1.0.2.ebuild,v 1.6 2009/04/19 19:49:39 scarabeus Exp $

EAPI=1

inherit kde

DESCRIPTION="KDE native window decoration with transparent titlebar, buttons and borders"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=13969"
SRC_URI="http://www.kde-look.org/content/files/13969-${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="|| ( kde-base/kwin:3.5 kde-base/kdebase:3.5 )"
RDEPEND="${DEPEND}"

need-kde 3.2
