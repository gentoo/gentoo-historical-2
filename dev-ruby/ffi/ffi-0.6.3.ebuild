# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ffi/ffi-0.6.3.ebuild,v 1.4 2010/09/18 17:20:40 armin76 Exp $

EAPI=2

# jruby → unneeded, this is part of the standard JRuby distribution,
# and would just install a dummy
USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_TASK_TEST="spec"

RUBY_FAKEGEM_TASK_DOC="doc:rdoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Ruby extension for programmatically loading dynamic libraries"
HOMEPAGE="http://wiki.github.com/ffi/ffi"

# Restore this after 0.6.3
#SRC_URI="http://github.com/${PN}/${PN}/tarball/${PV} -> ${PN}-git-${PV}.tgz"
SRC_URI="mirror://gentoo/${PN}-git-${PV}.tgz"
S="${WORKDIR}/${PN}-${PN}-*"

IUSE=""
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

RDEPEND="dev-libs/libffi"
DEPEND="${RDEPEND}"

ruby_add_bdepend dev-ruby/rake-compiler

each_ruby_compile() {
	${RUBY} -S rake compile || die "compile failed"
	${RUBY} -S rake -f gen/Rakefile || die "types.conf generation failed"
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc samples/* || die
}
