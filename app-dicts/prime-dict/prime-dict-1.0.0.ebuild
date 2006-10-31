# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/prime-dict/prime-dict-1.0.0.ebuild,v 1.7 2006/10/31 04:06:51 weeve Exp $

inherit ruby

DESCRIPTION="Dictionary files for PRIME input method"
HOMEPAGE="http://taiyaki.org/prime/"
SRC_URI="http://prime.sourceforge.jp/src/${P/_/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ppc ppc64 ~sparc x86"
IUSE=""

S="${WORKDIR}/${P%_*}"

RUBY_ECONF="--with-rubydir=/usr/lib/ruby/site_ruby"
