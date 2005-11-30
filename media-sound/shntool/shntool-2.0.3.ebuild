# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/shntool/shntool-2.0.3.ebuild,v 1.1 2004/11/20 18:19:35 chainsaw Exp $

IUSE="flac sox"

DESCRIPTION="shntool is a multi-purpose WAVE data processing and reporting utility"
HOMEPAGE="http://shnutils.freeshell.org/shntool/"
SRC_URI="http://shnutils.freeshell.org/shntool/source/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64 ~sparc"

DEPEND=">=media-sound/shorten-3.5.1
	flac? (>=media-libs/flac-1.1.0)
	sox? (>=media-sound/sox-12.17.4) "

src_install () {
	einstall || die
	dodoc doc/*
}

