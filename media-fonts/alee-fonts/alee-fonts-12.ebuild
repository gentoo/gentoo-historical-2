# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/alee-fonts/alee-fonts-12.ebuild,v 1.5 2009/05/30 17:06:28 nixnut Exp $

inherit font

DESCRIPTION="A Lee's Hangul truetype fonts"
HOMEPAGE="http://packages.debian.org/unstable/x11/ttf-alee"
SRC_URI="mirror://debian/pool/main/t/ttf-alee/ttf-alee_${PV}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE=""

FONT_SUFFIX="ttf"
FONT_S="${WORKDIR}/ttf-alee-${PV}"

S=${FONT_S}
