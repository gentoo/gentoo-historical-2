# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ffi/ffi-1.9.2.ebuild,v 1.1 2013/10/30 05:47:36 mrueg Exp $

EAPI=5

# jruby → unneeded, this is part of the standard JRuby distribution, and
# would just install a dummy.
USE_RUBY="ruby18 ruby19 ruby20"

RUBY_FAKEGEM_TASK_TEST="specs"

RUBY_FAKEGEM_TASK_DOC="doc:yard"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby extension for programmatically loading dynamic libraries"
HOMEPAGE="http://wiki.github.com/ffi/ffi"

SRC_URI="http://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${PN}-git-${PV}.tgz"

IUSE=""
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"

RDEPEND+=" virtual/libffi"
DEPEND+=" virtual/libffi"

ruby_add_bdepend "dev-ruby/rake-compiler dev-ruby/yard
	test? ( dev-ruby/rspec:2 )"

ruby_add_rdepend "virtual/ruby-threads"

all_ruby_prepare() {
	sed -i -e '/tasks/ s:^:#:' \
		-e '/Gem::Tasks/,/end/ s:^:#:' Rakefile || die
}

each_ruby_compile() {
	${RUBY} -S rake compile || die "compile failed"
	${RUBY} -S rake -f gen/Rakefile || die "types.conf generation failed"
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc samples/*
}
