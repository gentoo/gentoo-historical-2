# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rubytorrent/rubytorrent-0.3.ebuild,v 1.1 2005/02/15 19:06:36 citizen428 Exp $

DESCRIPTION="A pure-Ruby BitTorrent peer library and toolset"
HOMEPAGE="http://rubytorrent.rubyforge.org/"
SRC_URI="http://rubyforge.org/frs/download.php/3017/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/ruby"

USE_RUBY="ruby18 ruby19"

src_install() {
	local sitelibdir=`ruby -r rbconfig -e 'puts Config::CONFIG["sitelibdir"]'`
	insinto "$sitelibdir"
	doins rubytorrent.rb
	insinto "$sitelibdir/rubytorrent"
	doins rubytorrent/*
	dodoc doc/* README ReleaseNotes.txt
	docinto examples
	dodoc dump-metainfo.rb dump-peers.rb make-metainfo.rb \
		rtpeer-ncurses.rb rtpeer.rb
}

pkg_postinstall() {
	einfo
	einfo "Examples on how to use this package can be found at /usr/share/doc/${PF}/examples/"
	einfo
}
