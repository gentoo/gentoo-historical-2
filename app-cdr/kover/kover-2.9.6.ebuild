# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/kover/kover-2.9.6.ebuild,v 1.1 2005/01/01 14:09:28 dragonheart Exp $

inherit kde

DESCRIPTION="KDE program for CD Cover Creation"
HOMEPAGE="http://lisas.de/kover/"
SRC_URI="http://lisas.de/kover/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE=""

RDEPEND="media-libs/libvorbis
	media-libs/tiff
	media-libs/jpeg
	media-libs/libpng
	sys-libs/zlib
	virtual/libc"
DEPEND="${RDEPEND}
	sys-apps/gawk
	sys-devel/libtool
	sys-devel/gettext
	dev-lang/perl
	sys-devel/gcc"
need-kde 3
