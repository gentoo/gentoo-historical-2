# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/filelight/filelight-1.0_beta2-r2.ebuild,v 1.1 2004/08/30 13:34:56 gmsoft Exp $

inherit kde flag-o-matic

MY_P=${P/_/-}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Filelight is a tool to display where the space is used on the harddisk"
HOMEPAGE="http://www.methylblue.com/filelight/"
SRC_URI="http://www.methylblue.com/filelight/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64 ~hppa"
IUSE="arts"

need-kde 3

src_compile() {
	local myconf

	use arts || myconf="${myconf} --without-arts"

	# Unconditionally use -fPIC for libs (#55238)
	sed -e '/^CPPFLAGS/s/$/ -fPIC/' -i src/part/radialmap/Makefile.in

	kde_src_compile all
}
