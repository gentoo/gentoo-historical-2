# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/pdf-reader/pdf-reader-0.8.2.ebuild,v 1.1 2010/01/28 19:10:12 flameeyes Exp $

EAPI=2

GITHUB_USER=yob

USE_RUBY="ruby18 ruby19 jruby"

RUBY_FAKEGEM_TASK_TEST="spec"

RUBY_FAKEGEM_TASK_DOC="doc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc TODO"

inherit ruby-fakegem

DESCRIPTION="PDF parser conforming as much as possible to the PDF specification from Adobe"
HOMEPAGE="http://github.com/yob/pdf-reader/"

SRC_URI="http://github.com/${GITHUB_USER}/${PN}/tarball/v${PV} -> ${PN}-git-${PV}.tgz"
S="${WORKDIR}/${GITHUB_USER}-${PN}-1935d97"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend dev-ruby/ascii85

# rspec is loaded even during doc generation, so keep it around :(
ruby_add_bdepend "dev-ruby/rake dev-ruby/rspec"

all_ruby_prepare() {
	# Avoid forcing rcov on, this also seem to resolve a problem in
	# tests with US_ASCII encoding.
	sed -i \
		-e '/rcov/s:true:false:' \
		Rakefile || die "Rakefile fix failed"
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/* || die
}
