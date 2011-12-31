# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mail/mail-2.3.0.ebuild,v 1.2 2011/12/31 20:19:29 grobian Exp $

EAPI=4
USE_RUBY="ruby18 ruby19 ree18"

RUBY_FAKEGEM_TASK_TEST="spec"

RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.rdoc TODO.rdoc"

RUBY_FAKEGEM_GEMSPEC="mail.gemspec"

inherit ruby-fakegem

GITHUB_USER="mikel"
COMMIT="e8ec8d53c4f5c889691630d0422b9dc044762f1b"

DESCRIPTION="An email handling library"
HOMEPAGE="https://github.com/mikel/mail"
SRC_URI="https://github.com/${GITHUB_USER}/mail/tarball/${COMMIT} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="2.3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RUBY_S="${GITHUB_USER}-${PN}-*"

ruby_add_rdepend "
	>=dev-ruby/activesupport-2.3.6
	>=dev-ruby/i18n-0.4.0
	>=dev-ruby/mime-types-1.16
	>=dev-ruby/treetop-1.4.8"

ruby_add_bdepend "doc? ( dev-ruby/rspec:0 )
	test? ( dev-ruby/rspec:0 )"

all_ruby_prepare() {
	sed -i -e '/[Bb]undle/d' -e '6d' Rakefile || die "Unable to remove Bundler code."

	# Fix up dependencies to match our own.
	sed -i -e 's/~>/>=/' mail.gemspec || die "Unable to fix up dependencies."
}

each_ruby_prepare() {
	# Comment out failing specs on ruby19. Reported upstream:
	# https://github.com/mikel/mail/issues/318
	case ${RUBY} in
		*ruby19)
			sed -i -e '/should return itself on sort/,/end/ s:^:#:' spec/mail/parts_list_spec.rb || die
			sed -i -e '/should encode a non us-ascii filename/,/^    end/ s:^:#:' spec/mail/fields/content_type_field_spec.rb || die
			;;
	esac
}
