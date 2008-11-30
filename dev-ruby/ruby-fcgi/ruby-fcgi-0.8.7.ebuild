# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-fcgi/ruby-fcgi-0.8.7.ebuild,v 1.6 2008/11/30 16:32:04 maekke Exp $

inherit ruby

DESCRIPTION="FastCGI library for Ruby"
HOMEPAGE="http://rubyforge.org/projects/fcgi/"
SRC_URI="http://rubyforge.org/frs/download.php/11368/${P}.tar.gz"

KEYWORDS="amd64 ~ia64 ~ppc ppc64 ~sparc x86 ~x86-fbsd"
LICENSE="Ruby"

DEPEND="dev-libs/fcgi"

IUSE=""

# Use a custom src_install instead of the default one in ruby.eclass
# because the one in ruby.eclass does not include setting the prefix
# for the installation step.
src_install() {
	RUBY_ECONF="${RUBY_ECONF} ${EXTRA_ECONF}"

	${RUBY} install.rb install --prefix="${D}" "$@" \
		${RUBY_ECONF} || die "install.rb install failed"

	cd "${S}"
	dodoc ChangeLog README README.signals
}
