# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rubygems/rubygems-1.1.1.ebuild,v 1.5 2008/06/29 21:18:48 bluebird Exp $

inherit ruby

DESCRIPTION="Centralized Ruby extension management system"
HOMEPAGE="http://rubyforge.org/projects/rubygems/"
LICENSE="|| ( Ruby GPL-2 )"

# Needs to be installed first
RESTRICT="test"

# The URL depends implicitly on the version, unfortunately. Even if you
# change the filename on the end, it still downloads the same file.
SRC_URI="mirror://rubyforge/${PN}/${P}.tgz"

KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 sparc ~x86 ~x86-fbsd"
SLOT="0"
IUSE="doc server"
DEPEND=">=dev-lang/ruby-1.8"
PDEPEND="server? ( dev-ruby/builder )" # index_gem_repository.rb

USE_RUBY="ruby18"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-setup.patch"
}

src_compile() {
	# Allowing ruby_src_compile would be bad with the new setup.rb
	:
}

src_install() {
	# RUBYOPT=-rauto_gem without rubygems installed will cause ruby to fail, bug #158455
	export RUBYOPT="${GENTOO_RUBYOPT}"

	ver=$(${RUBY} -r rbconfig -e 'print Config::CONFIG["ruby_version"]')

	# rubygems tries to create GEM_HOME if it doesn't exist, upsetting sandbox,
	# bug #202109
	export GEM_HOME="${D}/usr/$(get_libdir)/ruby/gems/${ver}"
	keepdir /usr/$(get_libdir)/ruby/gems/$ver/{doc,gems,cache,specifications}

	myconf=""
	if ! use doc; then
		myconf="${myconf} --no-ri"
		myconf="${myconf} --no-rdoc"
	fi

	${RUBY} setup.rb $myconf --prefix="${D}" || die "setup.rb install failed"

	dosym gem18 /usr/bin/gem || die "dosym gem failed"

	dodoc README || die "dodoc README failed"

	cp "${FILESDIR}/auto_gem.rb" "${D}"/$(${RUBY} -r rbconfig -e 'print Config::CONFIG["sitedir"]') || die "cp auto_gem.rb failed"
	doenvd "${FILESDIR}/10rubygems" || die "doenvd 10rubygems failed"

	if use server; then
		newinitd "${FILESDIR}/init.d-gem_server2" gem_server || die "newinitd failed"
		newconfd "${FILESDIR}/conf.d-gem_server" gem_server || die "newconfd failed"
	fi
}

pkg_postinst()
{
	SOURCE_CACHE="/usr/$(get_libdir)/ruby/gems/$ver/source_cache"
	if [[ -e "${SOURCE_CACHE}" ]]; then
		rm "${SOURCE_CACHE}"
	fi

	ewarn "If you have previously switched to using ruby18_with_gems using ruby-config, this"
	ewarn "package has removed that file and makes it unnecessary anymore."
	ewarn "Please use ruby-config to revert back to ruby18."
}

pkg_postrm()
{
	ewarn "If you have uninstalled dev-ruby/rubygems. Ruby applications are unlikely"
	ewarn "to run in current shells because of missing auto_gem."
	ewarn "Please run \"unset RUBYOPT\" in your shells before using ruby"
	ewarn "or start new shells"
	ewarn
	ewarn "If you have not uninstalled dev-ruby/rubygems, please do not unset "
	ewarn "RUBYOPT"
}
