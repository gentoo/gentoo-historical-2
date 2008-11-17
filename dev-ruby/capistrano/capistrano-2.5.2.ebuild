# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/capistrano/capistrano-2.5.2.ebuild,v 1.1 2008/11/17 05:59:26 graaff Exp $

inherit gems

DESCRIPTION="A distributed application deployment system"
HOMEPAGE="http://capify.org/"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=">=dev-lang/ruby-1.8.2
	>=dev-ruby/rubygems-1.3.0
	>=dev-ruby/net-ssh-2.0.0
	>=dev-ruby/net-sftp-2.0.0
	>=dev-ruby/net-scp-1.0.0
	>=dev-ruby/net-ssh-gateway-1.0.0
	>=dev-ruby/highline-1.2.7"
PDEPEND="dev-ruby/capistrano-launcher"

src_install() {
	gems_src_install

	# Deleted cap, as it will be provided by capistrano-launcher
	rm "${D}/usr/bin/cap"
	rm "${D}/${GEMSDIR}/bin/cap"
}
