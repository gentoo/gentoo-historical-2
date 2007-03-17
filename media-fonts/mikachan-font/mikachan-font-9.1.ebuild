# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/mikachan-font/mikachan-font-9.1.ebuild,v 1.10 2007/03/17 16:29:20 corsair Exp $

inherit font

MY_PN="${PN/-/}"

DESCRIPTION="Mikachan Japanese TrueType fonts"
# taken from
#SRC_URI="http://mikachan.sourceforge.jp/mikachanALL.exe
#	http://mikachan.sourceforge.jp/puchi.exe"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	http://dev.gentoo.org/~usata/${P}.tar.bz2"
HOMEPAGE="http://mikachan-font.com/"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ia64 ppc ~ppc-macos ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

FONT_SUFFIX="ttc"
