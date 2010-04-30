# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/parsetree/parsetree-3.0.5.ebuild,v 1.1 2010/04/30 11:10:32 graaff Exp $

EAPI=2

USE_RUBY="ruby18"

RUBY_FAKEGEM_NAME="ParseTree"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.txt History.txt"

inherit ruby-fakegem

DESCRIPTION="ParseTree extracts the parse tree for a Class or method and returns it as a s-expression."
HOMEPAGE="http://www.zenspider.com/ZSS/Products/ParseTree/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

ruby_add_rdepend '>=dev-ruby/ruby-inline-3.7.0 >=dev-ruby/sexp-processor-3.0.0'
ruby_add_bdepend test "dev-ruby/hoe dev-ruby/hoe-seattlerb virtual/ruby-minitest dev-ruby/ruby2ruby"
ruby_add_bdepend doc "dev-ruby/hoe dev-ruby/hoe-seattlerb"

src_compile() {
	chmod 0755 ${WORKDIR/work/homedir} || die "Failed to fix permissions on home"
	ruby-ng_src_compile
}

src_test() {
	chmod 0755 ${WORKDIR/work/homedir} || die "Failed to fix permissions on home"
	ruby-ng_src_test
}
