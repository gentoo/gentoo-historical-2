# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/kaffeine/kaffeine-0.4.3.ebuild,v 1.2 2004/05/11 04:05:02 weeve Exp $

inherit kde
need-kde 3.1

DESCRIPTION="The Kaffeine media player for KDE3 based on xine-lib."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
RESTRICT="nomirror"
HOMEPAGE="http://kaffeine.sourceforge.net/"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc"

IUSE=""
SLOT="0"

DEPEND="${DEPEND}
	>=media-libs/xine-lib-1_rc3
	sys-devel/gettext"

