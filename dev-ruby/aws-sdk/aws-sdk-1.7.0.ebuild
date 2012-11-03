# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/aws-sdk/aws-sdk-1.7.0.ebuild,v 1.1 2012/11/03 21:35:38 flameeyes Exp $

EAPI=4

USE_RUBY="ruby18 ruby19 ree18"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

RUBY_FAKEGEM_EXTRAINSTALL="ca-bundle.crt"

GITHUB_USER="amazonwebservices"
GITHUB_PROJECT="${PN}-for-ruby"
RUBY_S="${GITHUB_USER}-${GITHUB_PROJECT}-*"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Official SDK for Amazon Web Services"
HOMEPAGE="http://aws.amazon.com/sdkforruby"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_PROJECT}/tarball/${PV} -> ${GITHUB_PROJECT}-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "virtual/ruby-ssl
	>=dev-ruby/httparty-0.7
	>=dev-ruby/json-1.4
	>=dev-ruby/nokogiri-1.4.4
	>=dev-ruby/uuidtools-2.1"

all_ruby_prepare() {
	sed -i -e 's:~>:>=:' "${RUBY_FAKEGEM_GEMSPEC}" || die
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}
	doins -r recipebook samples
}
