# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rake/rake-0.4.15-r1.ebuild,v 1.3 2005/03/30 16:16:28 hansmi Exp $

inherit ruby gems

USE_RUBY="ruby18 ruby19"
DESCRIPTION="Make-like scripting in Ruby"
HOMEPAGE="http://rake.rubyforge.org/"
# The URL depends implicitly on the version, unfortunately. Even if you
# change the filename on the end, it still downloads the same file.
SRC_URI="http://rubyforge.org/frs/download.php/2447/${P}.gem
	http://rubyforge.org/frs/download.php/2448/${P}.tgz"

LICENSE="MIT"
KEYWORDS="x86 ~ppc"
SLOT="0"
IUSE=""


src_unpack() {
	gems_src_unpack
	unpack ${P}.tgz || die "couldn't unpack ${P}.tgz"
}

src_install() {
	#We install both sitelib and gem versions:
	gems_src_install
	cd ${WORKDIR}/${P}
	DESTDIR="$D" ruby install.rb || die
}

src_test() {
	einfo "Skipping test. Rake can't seem to test itself."
}


