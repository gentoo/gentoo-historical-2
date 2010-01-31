# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/bones/bones-3.2.0.ebuild,v 1.1 2010/01/31 13:55:41 flameeyes Exp $

EAPI=2

USE_RUBY="ruby18 ruby19 jruby"

RUBY_FAKEGEM_TASK_TEST="spec:specdoc"

RUBY_FAKEGEM_TASK_DOC="doc:rdoc"
RUBY_FAKEGME_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

RUBY_FAKEGEM_EXTRAINSTALL="default"

inherit ruby-fakegem

DESCRIPTION="Tool that creates new Ruby projects from a code skeleton"
HOMEPAGE="http://github.com/TwP/bones"

IUSE=""
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_rdepend "
	>=dev-ruby/loquacious-1.4.1
	>=dev-ruby/little-plugger-1.1.1
	>=dev-ruby/rake-0.8.7"

ruby_add_bdepend test ">=dev-ruby/bones-extras-1.2.2"
ruby_add_bdepend doc ">=dev-ruby/bones-extras-1.2.2"
