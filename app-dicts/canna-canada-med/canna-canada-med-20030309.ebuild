# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/canna-canada-med/canna-canada-med-20030309.ebuild,v 1.1 2004/05/05 13:22:24 usata Exp $

inherit cannadic

IUSE="canna"

DESCRIPTION="Set of medical dictionaries for Canna"
HOMEPAGE="http://spica.onh.go.jp/med_dic/"
SRC_URI="http://dev.gentoo.org/~usata/distfiles/${P}.tar.gz"
#SRC_URI="ftp://spica.onh.go.jp/pub/med_dic/canna/canada_med_fbsd.tar.gz"

LICENSE="canada-med"
SLOT="0"
KEYWORDS="~x86 ~alpha"

DEPEND="canna? ( >=canna-3.6_p4 )"

S="${WORKDIR}/canada_med"

CANNADICS="med henkaku medinst oldchar xfs medx"
DOCS="COPYRIGHT.canadamed.ja INSTALL.fbsd.ja"
