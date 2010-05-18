# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/narray/narray-0.5.9_p7.ebuild,v 1.1 2010/05/18 12:47:06 flameeyes Exp $

EAPI=2

# jruby → native extension
USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="ChangeLog README.en README.ja SPEC.en SPEC.ja"

RUBY_FAKEGEM_VERSION="${PV/_p/.}"

inherit ruby-fakegem

DESCRIPTION="Numerical N-dimensional Array class"
HOMEPAGE="http://www.ir.isas.ac.jp/~masa/ruby/index-e.html"
SRC_URI="mirror://rubyforge/${PN}/${P/_/}.tar.gz"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

IUSE=""

S="${WORKDIR}/${P/_/}"

all_ruby_prepare() {
	# the tests aren't really written to be a testsuite, so the
	# failure cases will literally fail; ignore all of those ad
	# instead expect that the rest won't fail.
	sed -i -e '/[fF]ollowing will fail/,$ s:^:#:' \
		"${S}"/test/*.rb || die "sed failed"
}

each_ruby_configure() {
	${RUBY} extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake CFLAGS="${CFLAGS} -fPIC" archflag="${LDFLAGS}" || die "emake failed"
	cp -l ${PN}.so lib || die "copy of ${PN}.so failed"
}

each_ruby_test() {
	for unit in test/*; do
		# Skip over the FFTW test because it needs a package we don't
		# have in tree.
		[[ ${unit} == test/testfftw.rb ]] && continue

		${RUBY} -Ilib ${unit} || die "test ${unit} failed"
	done
}

each_ruby_install() {
	each_fakegem_install
}

all_ruby_install() {
	all_fakegem_install
}
