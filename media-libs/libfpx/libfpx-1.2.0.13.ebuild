# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libfpx/libfpx-1.2.0.13.ebuild,v 1.1 2007/05/20 22:59:51 sekretarz Exp $

inherit eutils

### uncomment the right variables depending on if we have a patchlevel or not
#MY_P=${PN}-${PV%.*}-${PV#*.*.*.}
#MY_P2=${PN}-${PV%.*}
MY_P=${PN}-${PV}
MY_P2=${PN}-${PV}

DESCRIPTION="A library for manipulating FlashPIX images"
HOMEPAGE="http://www.i3a.org/"
SRC_URI="ftp://ftp.imagemagick.org/pub/ImageMagick/delegates/${MY_P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

S=${WORKDIR}/${MY_P2}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc doc/*
}
