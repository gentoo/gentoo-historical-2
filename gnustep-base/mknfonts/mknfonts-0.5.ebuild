# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/mknfonts/mknfonts-0.5.ebuild,v 1.10 2005/04/04 20:47:46 gustavoz Exp $

inherit eutils gnustep

DESCRIPTION="Provides the tool to create .nfont packages suitable for use with gnustep-back-art."

HOMEPAGE="http://w1.423.telia.com/~u42308495/alex/backart/"
SRC_URI="http://w1.423.telia.com/~u42308495/alex/backart/mknfonts-0.5.tar.gz"
KEYWORDS="x86 ppc sparc ~alpha amd64"
SLOT="0"
LICENSE="GPL-2"

IUSE="${IUSE}"
DEPEND="${GNUSTEP_BASE_DEPEND}
	>=media-libs/freetype-2.1*"
RDEPEND="${DEPEND}"

egnustep_install_domain "System"

