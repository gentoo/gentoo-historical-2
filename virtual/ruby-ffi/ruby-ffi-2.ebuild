# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/ruby-ffi/ruby-ffi-2.ebuild,v 1.1 2013/11/11 13:41:21 mrueg Exp $

EAPI=2
USE_RUBY="ruby18 ruby19 ruby20 jruby"

inherit ruby-ng

DESCRIPTION="Virtual ebuild for the Ruby ffi library"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="ruby_targets_ruby18? ( dev-ruby/ffi[ruby_targets_ruby18] )
	ruby_targets_ruby19? ( dev-ruby/ffi[ruby_targets_ruby19] )
	ruby_targets_ruby20? ( dev-ruby/ffi[ruby_targets_ruby20] )
	ruby_targets_jruby? ( dev-java/jruby )"
DEPEND=""

pkg_setup() { :; }
src_unpack() { :; }
src_prepare() { :; }
src_compile() { :; }
src_install() { :; }
pkg_preinst() { :; }
pkg_postinst() { :; }
