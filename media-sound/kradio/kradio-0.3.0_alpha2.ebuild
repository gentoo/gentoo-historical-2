# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/kradio/kradio-0.3.0_alpha2.ebuild,v 1.1 2003/12/12 10:34:33 phosphan Exp $

inherit kde-base

S=${WORKDIR}/${P/_al/-al}

MY_PATCH="ksimus-patch-0.3.6-2"
DESCRIPTION="kradio is a radio tuner application for KDE"
HOMEPAGE="http://sourceforge.net/projects/kradio/"
KEYWORDS="~x86"
SRC_URI="mirror://sourceforge/${PN}/${P/_al/-al}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

need-kde 3
