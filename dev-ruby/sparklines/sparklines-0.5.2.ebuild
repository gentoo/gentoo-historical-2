# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/sparklines/sparklines-0.5.2.ebuild,v 1.3 2009/06/13 07:20:10 graaff Exp $

inherit ruby

DESCRIPTION="Create sparklines, small graphs to be used inline in texts."
HOMEPAGE="http://sparklines.rubyforge.org/"
SRC_URI="mirror://rubyforge/${PN}/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND="dev-ruby/rmagick"
DEPEND="doc? ( dev-ruby/rake
		dev-ruby/hoe )
	test? ( dev-ruby/rake
		dev-ruby/hoe
		dev-ruby/tidy_table
		dev-ruby/dust )"

USE_RUBY="ruby18"

src_compile() {
	if use doc; then
		rake rerocs || die "rake rerdoc failed"
	fi
}

src_test() {
	for ruby in $USE_RUBY; do
		[[ -n `type -p $ruby` ]] || continue
		$ruby $(type -p rake) test || die "testsuite failed"
	done
}

src_install() {
	pushd lib
	doruby -r * || die "doruby failed"
	popd

	if use doc; then
		dohtml -r doc/* || die "dohtml failed"
	fi

	dodoc History.txt README.txt || die "dodoc failed"

	insinto $(${RUBY} -r rbconfig -e 'print Config::CONFIG["vendorlibdir"]' | sed -e 's:vendor_ruby:gems:')/specifications
	sed -e "s:@VERSION@:${PV}:" "${FILESDIR}"/${PN}.gemspec > "${T}"/${P}.gemspec
	doins "${T}"/${P}.gemspec || die "Unable to install fake gemspec"
}
