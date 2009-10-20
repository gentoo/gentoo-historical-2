# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/gettext_activerecord/gettext_activerecord-2.0.4.ebuild,v 1.1 2009/10/20 09:12:24 graaff Exp $

inherit gems

DESCRIPTION="An L10 library for ActiveRecord."
HOMEPAGE="http://www.yotabanana.com/hiki/ruby-gettext-rails.html"
LICENSE="Ruby"

KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""

USE_RUBY="ruby18"

RDEPEND=">=dev-ruby/ruby-gettext-2.0.4
	>=dev-ruby/activerecord-2.3.2"
DEPEND="${RDEPEND}"
