# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-taglib/ruby-taglib-1.1.ebuild,v 1.1 2009/07/05 08:25:29 graaff Exp $

inherit ruby

DESCRIPTION="Ruby bindings for the taglib, allowing to access MP3, OGG, and FLAC tags"
HOMEPAGE="http://www.hakubi.us/ruby-taglib/"
SRC_URI="http://www.hakubi.us/ruby-taglib/${P}.tar.bz2"
USE_RUBY="ruby18 ruby19"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="media-libs/taglib"

src_install() {
	ruby_src_install
	dodoc README
}
