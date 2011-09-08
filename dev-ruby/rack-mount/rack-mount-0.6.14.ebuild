# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rack-mount/rack-mount-0.6.14.ebuild,v 1.5 2011/09/08 18:04:28 grobian Exp $

EAPI="2"
USE_RUBY="ruby18 ree18 jruby"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem eutils

DESCRIPTION="A stackable dynamic tree based Rack router."
HOMEPAGE="https://github.com/rails/rack-mount"

LICENSE="MIT"
SLOT="0.6"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-solaris"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rack-1.0.0"
