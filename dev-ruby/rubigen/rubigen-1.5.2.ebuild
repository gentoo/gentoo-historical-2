# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rubigen/rubigen-1.5.2.ebuild,v 1.1 2009/07/05 07:25:06 graaff Exp $

inherit gems

USE_RUBY="ruby18"
DESCRIPTION="A framework to allow Ruby applications to generate file/folder stubs."
HOMEPAGE="http://drnic.github.com/rubigen"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-ruby/activesupport-2.2.2
	>=dev-ruby/rubygems-1.3.1"
DEPEND="${RDEPEND}"
