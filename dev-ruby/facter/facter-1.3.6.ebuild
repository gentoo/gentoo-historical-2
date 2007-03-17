# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/facter/facter-1.3.6.ebuild,v 1.1 2007/03/17 17:23:24 nakano Exp $

inherit ruby

DESCRIPTION="A cross-platform Ruby library for retrieving facts from operating systems"
LICENSE="GPL-2"
HOMEPAGE="http://reductivelabs.com/projects/facter/index.html"
SRC_URI="http://reductivelabs.com/downloads/${PN}/${P}.tgz"

SLOT="0"
IUSE=""
KEYWORDS="~x86 ~amd64"

USE_RUBY="ruby18"

src_compile() {
	:
}


src_install() {
	DESTDIR="${D}" ruby_einstall || die
	DESTDIR="${D}" erubydoc
}
