# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/prime-dict/prime-dict-0.8.3.ebuild,v 1.2 2004/06/24 21:45:01 agriffis Exp $

inherit ruby

IUSE=""

DESCRIPTION="Dictionary files for PRIME input method"
HOMEPAGE="http://taiyaki.org/prime/"
SRC_URI="http://prime.sourceforge.jp/src/${P/_/-}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~alpha ~ppc"
SLOT="0"
S="${WORKDIR}/${P%_*}"

DEPEND="virtual/ruby"

EXTRA_ECONF="--with-rubydir=/usr/lib/ruby/site_ruby"
