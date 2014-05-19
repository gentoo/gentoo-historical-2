# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rrdtool-bindings/rrdtool-bindings-1.4.8.ebuild,v 1.2 2014/05/19 18:33:20 graaff Exp $

EAPI="5"

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-ng

MY_P=${P/-bindings}

DESCRIPTION="Ruby bindings for rrdtool."
HOMEPAGE="http://oss.oetiker.ch/rrdtool/"
SRC_URI="http://oss.oetiker.ch/rrdtool/pub/${MY_P}.tar.gz"
RUBY_S="$MY_P"/bindings/ruby

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE=""

# Block on older versions of rrdtool that installl the bindings
# themselves.
RDEPEND="${RDEPEND} net-analyzer/rrdtool !!<net-analyzer/rrdtool-1.4.8-r1"
DEPEND="${DEPEND} net-analyzer/rrdtool"

each_ruby_configure() {
	${RUBY} extconf.rb || die
}

each_ruby_compile() {
	emake V=1
}

each_ruby_test() {
	${RUBY} -I. test.rb || die
}

all_ruby_install() {
	dodoc CHANGES README
}

each_ruby_install() {
	DESTDIR=${D} emake install
}
