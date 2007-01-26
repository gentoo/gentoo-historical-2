# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rubygems/rubygems-0.9.1.ebuild,v 1.3 2007/01/26 15:59:37 pclouds Exp $

RUBY_BUG_145222=yes
inherit ruby

DESCRIPTION="Centralized Ruby extension management system"
HOMEPAGE="http://rubyforge.org/projects/rubygems/"
LICENSE="Ruby"

# The URL depends implicitly on the version, unfortunately. Even if you
# change the filename on the end, it still downloads the same file.
SRC_URI="http://rubyforge.org/frs/download.php/16452/${P}.tgz"

KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc-macos ~ppc64 ~sparc ~x86 ~x86-fbsd"
SLOT="0"
IUSE="doc server examples"
DEPEND=">=dev-lang/ruby-1.8"
PDEPEND="server? ( dev-ruby/builder )" # index_gem_repository.rb

PATCHES="${FILESDIR}/${P}-no_post_install.patch"
USE_RUBY="ruby18"

src_unpack() {
	ruby_src_unpack
	use doc || epatch "${FILESDIR}/${P}-no_rdoc_install.patch"
}

src_compile() {
	return
}

src_install() {
	# RUBYOPT=-rauto_gem without rubygems installed will cause ruby to fail, bug #158455
	export RUBYOPT="${GENTOO_RUBYOPT}"
	ver=$(${RUBY} -r rbconfig -e 'print Config::CONFIG["MAJOR"] + "." + Config::CONFIG["MINOR"]')
	GEM_HOME=${D}usr/lib/ruby/gems/$ver ruby_src_install
	cp "${FILESDIR}/auto_gem.rb" "${D}"/$(${RUBY} -r rbconfig -e 'print Config::CONFIG["sitedir"]')
	keepdir /usr/lib/ruby/gems/$ver/doc
	doenvd "${FILESDIR}/10rubygems"
}

src_test() {
	#rake test || die "test failed"
	for i in test/{test,functional}*.rb; do
		ruby ${i} || die "$i failed"
	done
}

pkg_postinst()
{
	ewarn "If you have previously switched to using ruby18_with_gems using ruby-config, this"
	ewarn "package has removed that file and makes it unnecessary anymore.	Please use ruby-config"
	ewarn "to revert back to ruby18."
}

pkg_postrm()
{
	# If we potentially downgraded, then getting rid of RUBYOPT from env.d is probably a smart idea.
	env-update
	source /etc/profile
	ewarn "You have removed dev-ruby/rubygems. Ruby applications are unlikely"
	ewarn "to run in current shells because of missing auto_gem."
	ewarn "Please source /etc/profile in your shells before using ruby"
	ewarn "or start new shells"
}
