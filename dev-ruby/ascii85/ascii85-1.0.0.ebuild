# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ascii85/ascii85-1.0.0.ebuild,v 1.1 2010/01/28 19:09:26 flameeyes Exp $

EAPI=2

USE_RUBY="ruby18 ruby19 jruby"

RUBY_FAKEGEM_TASK_TEST="spec"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.txt History.txt"

RUBY_FAKEGEM_NAME="Ascii85"

inherit ruby-fakegem

DESCRIPTION="Methods for encoding/decoding Adobe's binary-to-text encoding of the same name."
HOMEPAGE="http://ascii85.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend dev-ruby/hoe
ruby_add_bdepend test dev-ruby/rspec
