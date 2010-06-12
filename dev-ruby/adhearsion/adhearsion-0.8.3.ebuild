# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/adhearsion/adhearsion-0.8.3.ebuild,v 1.2 2010/06/12 19:45:00 graaff Exp $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="'Adhesion you can hear' for integrating VoIP"
HOMEPAGE="http://adhearsion.com"
IUSE=""

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="
	>=dev-ruby/rubigen-1.0.6
	>=dev-ruby/log4r-1.0.5"
DEPEND="${RDEPEND}
	>=dev-ruby/rake-0.7.1"
